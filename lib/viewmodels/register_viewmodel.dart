import 'package:flutter/foundation.dart';

import '../data/models/user_role.dart';
import '../data/repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel(this._repo, this.role);

  final AuthRepository _repo;
  final UserRole role;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;
  String? _error;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;
  bool get acceptedTerms => _acceptedTerms;
  String? get error => _error;

  /// Solo los estudiantes quedan vinculados a un dispositivo.
  bool get bindsDevice => role == UserRole.student;

  String get codeLabel => role == UserRole.student ? 'Código estudiantil' : 'Código docente';

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmVisibility() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  void setAcceptedTerms(bool value) {
    _acceptedTerms = value;
    if (value) _error = null;
    notifyListeners();
  }

  /// Devuelve `true` si la cuenta se creó (ver [error] si no).
  Future<bool> register({
    required String fullName,
    required String code,
    required String email,
    required String password,
  }) async {
    if (!_acceptedTerms) {
      _error = 'Debes aceptar los términos y el tratamiento de datos.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _repo.register(
        fullName: fullName,
        code: code,
        email: email,
        password: password,
        role: role,
      );
      return true;
    } on AuthFailure catch (e) {
      _error = e.message;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
