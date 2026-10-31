import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import '../models/app_user.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../services/device_service.dart';
import '../services/email_service.dart';
import '../services/user_service.dart';

/// Error de autenticación con un mensaje listo para mostrar al usuario.
class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// A dónde debe ir el usuario después de iniciar sesión o al abrir la app.
enum AuthDestination { roleSelection, verifyEmail, home }

/// Único punto de entrada de los ViewModels a la autenticación.
/// Coordina Firebase Auth, el perfil en Firestore y la vinculación del dispositivo.
class AuthRepository {
  AuthRepository({
    AuthService? auth,
    UserService? users,
    DeviceService? device,
    EmailService? email,
  })  : _auth = auth ?? AuthService(),
        _users = users ?? UserService(),
        _device = device ?? DeviceService(),
        _email = email ?? EmailService();

  final AuthService _auth;
  final UserService _users;
  final DeviceService _device;
  final EmailService _email;

  AppUser? _profile;

  /// Perfil del usuario con sesión iniciada.
  AppUser? get currentProfile => _profile;

  String? get currentEmail => _auth.currentUser?.email;

  /// Decide la pantalla inicial según la sesión guardada.
  Future<AuthDestination> restoreSession() async {
    final user = _auth.currentUser;
    if (user == null) return AuthDestination.roleSelection;
    try {
      final profile = await _users.getUser(user.uid);
      if (profile == null || !await _isAllowedDevice(profile)) {
        await signOut();
        return AuthDestination.roleSelection;
      }
      _profile = profile;
      final verified = await _auth.reloadAndCheckVerified();
      return verified ? AuthDestination.home : AuthDestination.verifyEmail;
    } catch (_) {
      return AuthDestination.roleSelection;
    }
  }

  Future<AuthDestination> signIn({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) {
    return _guard(() async {
      final user = await _auth.signIn(_normalize(email), password);
      final profile = await _users.getUser(user.uid);

      if (profile == null) {
        await signOut();
        throw const AuthFailure('No encontramos tu perfil. Regístrate nuevamente.');
      }
      if (profile.role != expectedRole) {
        await signOut();
        throw AuthFailure(
          'Esta cuenta está registrada como ${profile.role.label.toLowerCase()}. '
          'Vuelve y elige ese rol.',
        );
      }
      if (!await _isAllowedDevice(profile)) {
        await signOut();
        throw const AuthFailure(
          'Tu cuenta está vinculada a otro dispositivo. '
          'Solo puedes registrar asistencia desde ese celular.',
        );
      }

      _profile = profile;
      return user.emailVerified ? AuthDestination.home : AuthDestination.verifyEmail;
    });
  }

  Future<void> register({
    required String fullName,
    required String code,
    required String email,
    required String password,
    required UserRole role,
  }) {
    return _guard(() async {
      // Se obtiene antes de crear la cuenta para no dejar cuentas a medias.
      final deviceId = role == UserRole.student ? await _device.getDeviceId() : null;

      final user = await _auth.createAccount(_normalize(email), password);
      final profile = AppUser(
        uid: user.uid,
        fullName: fullName.trim(),
        code: code.trim(),
        email: _normalize(email),
        role: role,
        deviceId: deviceId,
      );

      try {
        await _users.createUser(profile);
      } catch (_) {
        // Si el perfil no se pudo guardar, se elimina la cuenta de Auth
        // para que el usuario pueda intentarlo de nuevo con el mismo correo.
        await _auth.deleteCurrentUser();
        rethrow;
      }
      _profile = profile;

      try {
        await _email.sendVerification();
      } catch (_) {
        // El usuario puede reenviarlo desde la pantalla de verificación.
      }
    });
  }

  Future<void> resendVerificationEmail() => _guard(_email.sendVerification);

  Future<bool> checkEmailVerified() => _guard(_auth.reloadAndCheckVerified);

  Future<void> sendPasswordReset(String email) => _guard(() => _email.sendPasswordReset(_normalize(email)));

  Future<void> signOut() async {
    _profile = null;
    await _auth.signOut();
  }

  static String _normalize(String email) => email.trim().toLowerCase();

  Future<bool> _isAllowedDevice(AppUser profile) async {
    if (profile.role != UserRole.student) return true;
    return profile.deviceId == await _device.getDeviceId();
  }

  /// Convierte cualquier error técnico en un [AuthFailure] con texto en español.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_authMessage(e.code));
    } on DeviceAlreadyLinkedException {
      throw const AuthFailure(
        'Este celular ya está vinculado a otra cuenta de estudiante.',
      );
    } on FirebaseFunctionsException catch (e) {
      // Las Cloud Functions ya responden con mensajes en español.
      throw AuthFailure(switch (e.code) {
        'resource-exhausted' || 'invalid-argument' || 'unauthenticated' || 'internal' =>
          e.message ?? 'No pudimos enviar el correo.',
        'unavailable' => 'Sin conexión. Revisa tu internet e inténtalo de nuevo.',
        _ => 'No pudimos enviar el correo (${e.code}).',
      });
    } on FirebaseException catch (e) {
      throw AuthFailure(e.code == 'unavailable'
          ? 'Sin conexión. Revisa tu internet e inténtalo de nuevo.'
          : 'No pudimos completar la operación (${e.code}).');
    } on PlatformException {
      throw const AuthFailure('No se pudo identificar este dispositivo.');
    } catch (_) {
      throw const AuthFailure('Ocurrió un error inesperado. Inténtalo de nuevo.');
    }
  }

  static String _authMessage(String code) => switch (code) {
        'invalid-email' => 'El correo no es válido.',
        'user-disabled' => 'Esta cuenta fue deshabilitada. Contacta a soporte.',
        'user-not-found' || 'wrong-password' || 'invalid-credential' =>
          'Correo o contraseña incorrectos.',
        'email-already-in-use' => 'Ya existe una cuenta con este correo.',
        'weak-password' => 'La contraseña es muy débil.',
        'too-many-requests' => 'Demasiados intentos. Espera unos minutos.',
        'network-request-failed' => 'Sin conexión. Revisa tu internet.',
        'operation-not-allowed' =>
          'El inicio con correo no está habilitado en Firebase.',
        _ => 'No pudimos completar la operación ($code).',
      };
}
