import 'package:asistly/core/utils/validators.dart';
import 'package:asistly/viewmodels/email_verification_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    test('institutionalEmail', () {
      expect(Validators.institutionalEmail(''), isNotNull);
      expect(Validators.institutionalEmail('no-es-correo'), isNotNull);
      expect(Validators.institutionalEmail('ana.gomez@gmail.com'), isNotNull);
      expect(Validators.institutionalEmail('Ana.Gomez@UDLA.edu.co'), isNull);
      expect(Validators.institutionalEmail('ana.gomez@udla.edu.co'), isNull);
    });

    test('newPassword exige 8 caracteres con letras y números', () {
      expect(Validators.newPassword('abc12'), isNotNull);
      expect(Validators.newPassword('abcdefgh'), isNotNull);
      expect(Validators.newPassword('12345678'), isNotNull);
      expect(Validators.newPassword('clave2024'), isNull);
    });

    test('confirmPassword', () {
      expect(Validators.confirmPassword('clave2024', 'clave2025'), isNotNull);
      expect(Validators.confirmPassword('clave2024', 'clave2024'), isNull);
    });

    test('fullName pide nombre y apellido', () {
      expect(Validators.fullName('Valeria'), isNotNull);
      expect(Validators.fullName('Valeria Gómez'), isNull);
    });

    test('institutionalCode', () {
      expect(Validators.institutionalCode('12'), isNotNull);
      expect(Validators.institutionalCode('2024 108'), isNotNull);
      expect(Validators.institutionalCode('2024-10842'), isNull);
    });
  });

  test('maskEmail oculta el usuario', () {
    expect(EmailVerificationViewModel.maskEmail('usuario@udla.edu.co'), 'u***@udla.edu.co');
  });
}
