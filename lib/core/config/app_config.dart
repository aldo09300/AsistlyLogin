abstract final class AppConfig {
  static const universityName = 'Universidad de la Amazonia';

  /// Dominios de correo permitidos para registrarse e iniciar sesión.
  /// Vacío = se acepta cualquier dominio (útil mientras se prueba).
  /// Ejemplo: `['udla.edu.co']`.
  static const List<String> institutionalEmailDomains = ['udla.edu.co'];

  /// Segundos de espera antes de poder reenviar un correo.
  static const verificationResendCooldown = 45;
  static const passwordResetResendCooldown = 60;
}
