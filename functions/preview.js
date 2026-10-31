// Genera vistas previas locales de los correos: `npm run preview`.
const fs = require('node:fs');
const { verificationEmail, passwordResetEmail } = require('./templates');

const link = 'https://TU-PROYECTO.firebaseapp.com/__/auth/action?mode=verifyEmail&oobCode=EJEMPLO&lang=es';
fs.writeFileSync('preview-verificacion.html', verificationEmail({ name: 'Valeria', link }).html);
fs.writeFileSync('preview-restablecer.html', passwordResetEmail({ name: 'Valeria', link }).html);
console.log('Listo: preview-verificacion.html y preview-restablecer.html');
