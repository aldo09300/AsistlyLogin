import 'package:cloud_functions/cloud_functions.dart';

/// Envía los correos de autenticación a través de Cloud Functions,
/// que generan el enlace de Firebase y lo mandan con la plantilla de Asistly.
class EmailService {
  EmailService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instanceFor(region: 'us-central1');

  final FirebaseFunctions _functions;

  Future<void> sendVerification() =>
      _functions.httpsCallable('sendVerificationEmail').call<void>();

  Future<void> sendPasswordReset(String email) =>
      _functions.httpsCallable('sendPasswordResetEmail').call<void>({'email': email});
}
