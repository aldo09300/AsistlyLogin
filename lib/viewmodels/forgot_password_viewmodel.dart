import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';
import '../data/repositories/auth_repository.dart';

/// Lo usan "Recuperar contraseña" (envío) y "Revisa tu correo" (reenvío).
class ForgotPasswordViewModel extends ChangeNotifier {
  ForgotPasswordViewModel(this._repo, {String initialEmail = ''}) : _email = initialEmail;

  final AuthRepository _repo;

  String _email;
  bool _isLoading = false;
  String? _error;
  Timer? _cooldownTimer;
  int _secondsLeft = 0;
  bool _justResent = false;

  String get email => _email;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get secondsLeft => _secondsLeft;
  bool get canResend => !_isLoading && _secondsLeft == 0;

  String get resendLabel {
    if (_isLoading) return 'Enviando...';
    if (_justResent && _secondsLeft > 0) return 'Enlace reenviado';
    return 'Reenviar enlace';
  }

  /// Devuelve `true` si el correo se envió.
  Future<bool> sendReset(String email) async {
    _email = email.trim();
    return _send();
  }

  Future<void> resend() async {
    if (!canResend || _email.isEmpty) return;
    if (await _send()) {
      _justResent = true;
      _startCooldown();
    }
  }

  Future<bool> _send() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repo.sendPasswordReset(_email);
      return true;
    } on AuthFailure catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    _secondsLeft = AppConfig.passwordResetResendCooldown;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _secondsLeft--;
      if (_secondsLeft <= 0) {
        _secondsLeft = 0;
        _justResent = false;
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
    super.dispose();
  }
}
