import 'package:flutter/foundation.dart';

import '../data/models/user_role.dart';
import '../data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._repo, this.role);

  final AuthRepository _repo;
  final UserRole role;

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _error;

  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get error => _error;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  /// Devuelve a dónde navegar, o `null` si falló (ver [error]).
  Future<AuthDestination?> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      return await _repo.signIn(email: email, password: password, expectedRole: role);
    } on AuthFailure catch (e) {
      _error = e.message;
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
