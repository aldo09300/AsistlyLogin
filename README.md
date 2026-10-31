# Asistly — Módulo de inicio de sesión

App móvil en Flutter para el control de asistencia de la Universidad de la Amazonia. Este repositorio contiene la entrega del **módulo de cuentas**: desde abrir la app hasta llegar al Home.

Proyecto de la asignatura Programación Móvil — Ingeniería de Sistemas, Universidad de la Amazonia (Florencia, Caquetá).

## Integrantes

- Aldo Stiven Encarnacion Valderrama
- Alejandro Noreña Romero

## Qué incluye

- Pantalla de carga (splash) que recuerda la sesión iniciada.
- Selección de rol: docente o estudiante.
- Inicio de sesión con correo institucional (`@udla.edu.co`) y contraseña.
- Registro con nombre, código, correo y contraseña.
- Vinculación del estudiante a un solo celular.
- Verificación del correo con un enlace, con botón "Ya verifiqué mi correo" y reenvío.
- Recuperación de contraseña por correo.
- Reglas de seguridad de Cloud Firestore.
- Correos de verificación y recuperación con plantilla propia (Cloud Functions).

## Tecnologías

- Flutter y Dart
- Firebase Authentication y Cloud Firestore
- Cloud Functions (Node.js) para enviar los correos
- Provider para el manejo de estado

## Estructura

| Carpeta | Qué hay |
|---|---|
| `lib/views/` | Las pantallas |
| `lib/viewmodels/` | La lógica de cada pantalla |
| `lib/data/` | Modelos, servicios de Firebase y repositorio |
| `lib/core/` | Rutas, tema (colores y fuentes) y validadores |
| `functions/` | Cloud Functions que envían los correos |
| `firestore.rules` | Reglas de seguridad de la base de datos |
| `stitch/screens/` | Diseños de referencia de las pantallas |
| `test/` | Pruebas de los validadores |

## Cómo correrlo

Por seguridad, **este repositorio no incluye las credenciales de Firebase** (`lib/firebase_options.dart`, `android/app/google-services.json`, `.firebaserc`). Para correr la app hay que conectarla a un proyecto de Firebase propio:

1. Instalar [Flutter](https://docs.flutter.dev/get-started/install), el [Firebase CLI](https://firebase.google.com/docs/cli) y FlutterFire CLI (`dart pub global activate flutterfire_cli`).
2. Crear un proyecto en la [consola de Firebase](https://console.firebase.google.com/) y activar **Authentication** (correo y contraseña) y **Cloud Firestore**.
3. En la carpeta del proyecto, generar las credenciales:
   ```bash
   flutterfire configure --platforms=android,ios
   ```
4. Instalar dependencias y correr:
   ```bash
   flutter pub get
   flutter run
   ```
5. Subir las reglas de seguridad:
   ```bash
   firebase deploy --only firestore:rules
   ```

Las Cloud Functions de correo necesitan el plan Blaze y los secretos `GMAIL_USER`, `GMAIL_CLIENT_ID`, `GMAIL_CLIENT_SECRET` y `GMAIL_REFRESH_TOKEN` configurados en Secret Manager. Estos secretos nunca se guardan en el repositorio.
