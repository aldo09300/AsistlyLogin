import 'package:flutter/foundation.dart';

import '../data/repositories/auth_repository.dart';

class SplashViewModel extends ChangeNotifier {
  SplashViewModel(this._repo);

  final AuthRepository _repo;

  static const minDuration = Duration(milliseconds: 2200);

  /// Restaura la sesión mientras se muestra el splash (como mínimo [minDuration]).
  Future<AuthDestination> resolveStart() async {
    final results = await Future.wait([
      _repo.restoreSession(),
      Future<void>.delayed(minDuration),
    ]);
    return results.first as AuthDestination;
  }
}
