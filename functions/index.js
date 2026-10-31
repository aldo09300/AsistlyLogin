const crypto = require('node:crypto');
const { setGlobalOptions } = require('firebase-functions/v2');
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const logger = require('firebase-functions/logger');
const admin = require('firebase-admin');
const MailComposer = require('nodemailer/lib/mail-composer');

const { verificationEmail, passwordResetEmail } = require('./templates');

admin.initializeApp();
setGlobalOptions({ region: 'us-central1', maxInstances: 5 });

// Se configuran con `firebase functions:secrets:set` (nunca en el código).
const GMAIL_USER = defineSecret('GMAIL_USER');
const GMAIL_CLIENT_ID = defineSecret('GMAIL_CLIENT_ID');
const GMAIL_CLIENT_SECRET = defineSecret('GMAIL_CLIENT_SECRET');
const GMAIL_REFRESH_TOKEN = defineSecret('GMAIL_REFRESH_TOKEN');
const MAIL_SECRETS = [GMAIL_USER, GMAIL_CLIENT_ID, GMAIL_CLIENT_SECRET, GMAIL_REFRESH_TOKEN];

const ALLOWED_EMAIL = /^[^@\s]+@udla\.edu\.co$/;
const COOLDOWN_SECONDS = { verify: 45, reset: 60 };

let accessToken = { value: null, expiresAt: 0 };

/** Cambia el refresh token (permanente) por un access token de ~1 hora, con caché. */
async function getAccessToken() {
  if (accessToken.value && Date.now() < accessToken.expiresAt - 60_000) {
    return accessToken.value;
  }
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: GMAIL_CLIENT_ID.value(),
      client_secret: GMAIL_CLIENT_SECRET.value(),
      refresh_token: GMAIL_REFRESH_TOKEN.value(),
      grant_type: 'refresh_token',
    }),
  });
  const json = await res.json();
  if (!res.ok) throw new Error(`OAuth ${res.status}: ${json.error} ${json.error_description ?? ''}`);
  accessToken = { value: json.access_token, expiresAt: Date.now() + json.expires_in * 1000 };
  return accessToken.value;
}

/**
 * Envía con la API de Gmail (no SMTP). Así el correo sale desde los servidores
 * de Gmail sin registrar la IP de Google Cloud, que Microsoft 365 bloqueaba.
 */
async function sendMail(to, { subject, html, text }) {
  try {
    const mime = await new MailComposer({
      from: { name: 'Asistly', address: GMAIL_USER.value() },
      to,
      subject,
      html,
      text,
    }).compile().build();

    const res = await fetch('https://gmail.googleapis.com/gmail/v1/users/me/messages/send', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${await getAccessToken()}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ raw: mime.toString('base64url') }),
    });
    if (!res.ok) throw new Error(`Gmail API ${res.status}: ${await res.text()}`);
  } catch (err) {
    logger.error('Fallo al enviar correo', { to, error: err.message });
    throw new HttpsError('internal', 'No pudimos enviar el correo. Inténtalo más tarde.');
  }
}

/** La página de Firebase que abre el enlace se muestra en español. */
function inSpanish(link) {
  const url = new URL(link);
  url.searchParams.set('lang', 'es');
  return url.toString();
}

/** Evita que se use la función para inundar un buzón: un envío cada N segundos por clave. */
async function throttle(key, seconds) {
  const db = admin.firestore();
  const ref = db.collection('mailThrottle').doc(key);
  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const last = snap.exists ? snap.get('lastSentAt').toMillis() : 0;
    const wait = Math.ceil((last + seconds * 1000 - Date.now()) / 1000);
    if (wait > 0) {
      throw new HttpsError('resource-exhausted', `Espera ${wait} s para volver a enviarlo.`);
    }
    tx.set(ref, { lastSentAt: admin.firestore.FieldValue.serverTimestamp() });
  });
}

async function firstNameOf(uid) {
  const doc = await admin.firestore().collection('users').doc(uid).get();
  const fullName = doc.exists ? doc.get('fullName') : '';
  return (fullName || '').trim().split(/\s+/)[0] || '';
}

/** Envía el enlace de verificación al usuario con sesión iniciada. */
exports.sendVerificationEmail = onCall(
  { secrets: MAIL_SECRETS },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Inicia sesión para verificar tu correo.');
    }
    const user = await admin.auth().getUser(request.auth.uid);
    if (user.emailVerified) return { alreadyVerified: true };

    await throttle(`verify_${user.uid}`, COOLDOWN_SECONDS.verify);

    const link = inSpanish(await admin.auth().generateEmailVerificationLink(user.email));
    const name = await firstNameOf(user.uid);
    await sendMail(user.email, verificationEmail({ name, link }));
    return { sent: true };
  },
);

/**
 * Envía el enlace para restablecer la contraseña.
 * Responde igual exista o no la cuenta, para no revelar qué correos están registrados.
 */
exports.sendPasswordResetEmail = onCall(
  { secrets: MAIL_SECRETS },
  async (request) => {
    const email = String(request.data?.email ?? '').trim().toLowerCase();
    if (!ALLOWED_EMAIL.test(email)) {
      throw new HttpsError('invalid-argument', 'Usa tu correo institucional (@udla.edu.co).');
    }

    const emailHash = crypto.createHash('sha256').update(email).digest('hex');
    await throttle(`reset_${emailHash}`, COOLDOWN_SECONDS.reset);

    let user;
    try {
      user = await admin.auth().getUserByEmail(email);
    } catch (err) {
      if (err.code === 'auth/user-not-found') return { sent: true };
      throw err;
    }

    const link = inSpanish(await admin.auth().generatePasswordResetLink(email));
    const name = await firstNameOf(user.uid);
    await sendMail(email, passwordResetEmail({ name, link }));
    return { sent: true };
  },
);
