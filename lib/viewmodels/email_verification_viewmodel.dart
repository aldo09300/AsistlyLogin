import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';
import '../data/repositories/auth_repository.dart';

class EmailVerificationViewModel extends ChangeNotifier {
  EmailVerificationViewModel(this._repo) {
    _startCooldown();
    // Revisa periódicamente si el usuario ya tocó el enlace del correo.
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) => _poll());
  }

  final AuthRepository _repo;

  Timer? _cooldownTimer;
  Timer? _pollTimer;
  int _secondsLeft = 0;
  bool _isChecking = false;
  bool _isVerified = false;
  String? _message;

  int get secondsLeft => _secondsLeft;
  bool get canResend => _secondsLeft == 0;
  bool get isChecking => _isChecking;

  /// La View navega al home cuando esto pasa a `true`.
  bool get isVerified => _isVerified;

  /// Mensaje informativo o de error para mostrar en un SnackBar.
  String? get message => _message;

  String get countdownLabel => '00:${_secondsLeft.toString().padLeft(2, '0')}';

  String get maskedEmail => maskEmail(_repo.currentEmail ?? '');

  static String maskEmail(String email) {
    final at = email.indexOf('@');
    if (at <= 0) return email;
    return '${email[0]}***${email.substring(at)}';
  }

  void consumeMessage() => _message = null;

  Future<void> resend() async {
    if (!canResend) return;
    try {
      await _repo.resendVerificationEmail();
      _message = 'Te enviamos un nuevo correo de verificación.';
      _startCooldown();
    } on AuthFailure catch (e) {
      _message = e.message;
    }
    notifyListeners();
  }

  /// Botón "Ya verifiqué mi correo".
  Future<void> checkNow() async {
    if (_isChecking) return;
    _isChecking = true;
    notifyListeners();
    try {
      _isVerified = await _repo.checkEmailVerified();
      if (!_isVerified) {
        _message = 'Aún no detectamos la verificación. Revisa tu correo.';
      }
    } on AuthFailure catch (e) {
      _message = e.message;
    } finally {
      _isChecking = false;
      notifyListeners();
    }
  }

  Future<void> signOut() => _repo.signOut();

  Future<void> _poll() async {
    if (_isChecking || _isVerified) return;
    try {
      if (await _repo.checkEmailVerified()) {
        _isVerified = true;
        notifyListeners();
      }
    } on AuthFailure {
      // Silencioso: se volverá a intentar en el próximo ciclo.
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _secondsLeft = AppConfig.verificationResendCooldown;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _secondsLeft--;
      if (_secondsLeft <= 0) {
        _secondsLeft = 0;
        t.cancel();
      }
      notifyListeners();
    });
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _cooldownTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }
}
