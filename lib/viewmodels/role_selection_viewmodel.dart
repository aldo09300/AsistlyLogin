import 'package:flutter/foundation.dart';

import '../data/models/user_role.dart';

class RoleSelectionViewModel extends ChangeNotifier {
  UserRole _selected = UserRole.teacher;

  UserRole get selected => _selected;

  void select(UserRole role) {
    if (role == _selected) return;
    _selected = role;
    notifyListeners();
  }
}
