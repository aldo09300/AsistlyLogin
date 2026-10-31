import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_role.dart';

/// Perfil del usuario guardado en `users/{uid}`.
class AppUser {
  const AppUser({
    required this.uid,
    required this.fullName,
    required this.code,
    required this.email,
    required this.role,
    this.deviceId,
    this.createdAt,
  });

  final String uid;
  final String fullName;

  /// Código estudiantil o código docente.
  final String code;
  final String email;
  final UserRole role;

  /// Dispositivo al que está vinculada la cuenta (solo estudiantes).
  final String? deviceId;
  final DateTime? createdAt;

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  factory AppUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return AppUser(
      uid: doc.id,
      fullName: data['fullName'] as String? ?? '',
      code: data['code'] as String? ?? '',
      email: data['email'] as String? ?? '',
      role: UserRole.fromValue(data['role'] as String?),
      deviceId: data['deviceId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'fullName': fullName,
        'code': code,
        'email': email,
        'role': role.value,
        'deviceId': deviceId,
        'createdAt': FieldValue.serverTimestamp(),
      };
}
