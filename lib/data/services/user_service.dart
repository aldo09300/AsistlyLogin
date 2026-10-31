import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class DeviceAlreadyLinkedException implements Exception {}

/// Acceso a las colecciones `users` y `devices` de Cloud Firestore.
class UserService {
  UserService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');
  CollectionReference<Map<String, dynamic>> get _devices => _db.collection('devices');

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    return doc.exists ? AppUser.fromFirestore(doc) : null;
  }

  /// Crea el perfil. Si el usuario tiene `deviceId`, también reserva el
  /// dispositivo en `devices/{deviceId}` dentro de la misma transacción,
  /// para que un celular no pueda quedar vinculado a dos cuentas.
  Future<void> createUser(AppUser user) {
    return _db.runTransaction((tx) async {
      final deviceId = user.deviceId;
      if (deviceId != null) {
        final deviceRef = _devices.doc(deviceId);
        final device = await tx.get(deviceRef);
        if (device.exists) throw DeviceAlreadyLinkedException();
        tx.set(deviceRef, {'uid': user.uid, 'linkedAt': FieldValue.serverTimestamp()});
      }
      tx.set(_users.doc(user.uid), user.toFirestore());
    });
  }
}
