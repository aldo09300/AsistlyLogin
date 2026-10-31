// Plantillas de correo con la identidad visual de Asistly.
// HTML "a prueba de Outlook": tablas, estilos en línea y sin imágenes externas.

const C = {
  primary: '#00266F',
  primaryContainer: '#1A3D8F',
  accent: '#F6BE21',
  surface: '#F7F9FE',
  surfaceLow: '#F1F4F9',
  border: '#DBE1FF',
  text: '#181C20',
  muted: '#444651',
  outline: '#747683',
};
const FONT = "'Inter','Segoe UI',Roboto,Helvetica,Arial,sans-serif";

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function layout({ title, greeting, intro, buttonLabel, link, note }) {
  return `<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
</head>
<body style="margin:0;padding:0;background:${C.surface};">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:${C.surface};">
  <tr><td align="center" style="padding:32px 16px;">
    <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="max-width:560px;">

      <!-- Encabezado -->
      <tr><td style="background:${C.primary};border-radius:16px 16px 0 0;padding:28px 32px;">
        <span style="font-family:${FONT};font-size:26px;font-weight:700;color:#FFFFFF;letter-spacing:-0.5px;">Asistly</span><span style="font-family:${FONT};font-size:26px;font-weight:700;color:${C.accent};">.</span>
        <div style="font-family:${FONT};font-size:13px;color:#DBE1FF;margin-top:4px;">Tu asistencia, verificada</div>
      </td></tr>

      <!-- Contenido -->
      <tr><td style="background:#FFFFFF;padding:32px;border-left:1px solid ${C.border};border-right:1px solid ${C.border};">
        <h1 style="margin:0 0 16px;font-family:${FONT};font-size:22px;line-height:30px;font-weight:700;color:${C.primary};">${escapeHtml(title)}</h1>
        <p style="margin:0 0 8px;font-family:${FONT};font-size:15px;line-height:24px;color:${C.text};">${escapeHtml(greeting)}</p>
        <p style="margin:0 0 28px;font-family:${FONT};font-size:15px;line-height:24px;color:${C.muted};">${escapeHtml(intro)}</p>

        <!-- Botón -->
        <table role="presentation" cellpadding="0" cellspacing="0" style="margin:0 auto 28px;">
          <tr><td align="center" bgcolor="${C.accent}" style="border-radius:12px;">
            <a href="${escapeHtml(link)}" target="_blank" style="display:inline-block;padding:15px 32px;font-family:${FONT};font-size:15px;font-weight:700;color:${C.primary};text-decoration:none;border-radius:12px;">${escapeHtml(buttonLabel)}</a>
          </td></tr>
        </table>

        <!-- Nota -->
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:${C.surfaceLow};border-radius:12px;">
          <tr><td style="padding:14px 16px;font-family:${FONT};font-size:13px;line-height:20px;color:${C.muted};">
            <strong style="color:${C.primary};">Importante:</strong> ${escapeHtml(note)}
          </td></tr>
        </table>
      </td></tr>

      <!-- Pie -->
      <tr><td style="background:#FFFFFF;border:1px solid ${C.border};border-top:none;border-radius:0 0 16px 16px;padding:20px 32px;">
        <p style="margin:0;font-family:${FONT};font-size:12px;line-height:18px;color:${C.outline};">
          Asistly · Gestión de Asistencia Universitaria<br>Universidad de la Amazonia
        </p>
        <p style="margin:8px 0 0;font-family:${FONT};font-size:11px;line-height:16px;color:${C.outline};">
          Recibes este correo porque se usó esta dirección en Asistly. Si no fuiste tú, ignóralo: tu cuenta sigue segura.
        </p>
      </td></tr>

    </table>
  </td></tr>
</table>
</body>
</html>`;
}

function plainText({ greeting, intro, link, note }) {
  return `${greeting}\n\n${intro}\n\n${link}\n\n${note}\n\n— Asistly · Universidad de la Amazonia`;
}

function verificationEmail({ name, link }) {
  const content = {
    title: 'Verifica tu correo',
    greeting: name ? `Hola, ${name}:` : 'Hola:',
    intro:
      'Gracias por registrarte en Asistly. Confirma tu correo institucional para activar tu cuenta y empezar a registrar asistencia.',
    buttonLabel: 'Verificar mi correo',
    link,
    note: 'después de verificar, vuelve a la app Asistly; continuará automáticamente.',
  };
  return {
    subject: 'Verifica tu correo para activar Asistly',
    html: layout(content),
    text: plainText(content),
  };
}

function passwordResetEmail({ name, link }) {
  const content = {
    title: 'Restablece tu contraseña',
    greeting: name ? `Hola, ${name}:` : 'Hola:',
    intro:
      'Recibimos una solicitud para cambiar la contraseña de tu cuenta de Asistly. Toca el botón para crear una nueva.',
    buttonLabel: 'Crear nueva contraseña',
    link,
    note: 'el enlace vence en 1 hora. Si no pediste este cambio, ignora este correo.',
  };
  return {
    subject: 'Restablece tu contraseña de Asistly',
    html: layout(content),
    text: plainText(content),
  };
}

module.exports = { verificationEmail, passwordResetEmail };
