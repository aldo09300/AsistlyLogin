import 'package:firebase_auth/firebase_auth.dart';

/// Acceso directo a Firebase Authentication.
class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Future<User> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user!;
  }

  Future<User> createAccount(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return cred.user!;
  }

  /// Recarga el usuario desde el servidor y devuelve si ya verificó su correo.
  Future<bool> reloadAndCheckVerified() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> deleteCurrentUser() async => _auth.currentUser?.delete();

  Future<void> signOut() => _auth.signOut();
}
