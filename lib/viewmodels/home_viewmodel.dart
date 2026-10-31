import 'package:flutter/foundation.dart';

import '../data/models/app_user.dart';
import '../data/repositories/auth_repository.dart';

/// Home provisional: muestra el perfil y permite cerrar sesión.
/// Se reemplazará por los Home de docente y estudiante.
class HomeViewModel extends ChangeNotifier {
  HomeViewModel(this._repo);

  final AuthRepository _repo;

  AppUser? get user => _repo.currentProfile;

  Future<void> signOut() => _repo.signOut();
}
