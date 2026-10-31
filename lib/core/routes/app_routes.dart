import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/user_role.dart';
import '../../data/repositories/auth_repository.dart';
import '../../viewmodels/email_verification_viewmodel.dart';
import '../../viewmodels/forgot_password_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../../viewmodels/role_selection_viewmodel.dart';
import '../../viewmodels/splash_viewmodel.dart';
import '../../views/auth/check_email_view.dart';
import '../../views/auth/email_verification_view.dart';
import '../../views/auth/forgot_password_view.dart';
import '../../views/auth/login_view.dart';
import '../../views/auth/register_view.dart';
import '../../views/home/home_view.dart';
import '../../views/role_selection/role_selection_view.dart';
import '../../views/splash/splash_view.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const roleSelection = '/role';
  static const login = '/login';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const forgotPassword = '/forgot-password';
  static const checkEmail = '/check-email';
  static const home = '/home';

  /// Cada ruta crea su ViewModel y lo inyecta con [ChangeNotifierProvider],
  /// así la View solo conoce a su ViewModel y nunca a Firebase.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case roleSelection:
        page = ChangeNotifierProvider(
          create: (_) => RoleSelectionViewModel(),
          child: const RoleSelectionView(),
        );
      case login:
        final role = settings.arguments as UserRole? ?? UserRole.student;
        page = ChangeNotifierProvider(
          create: (c) => LoginViewModel(c.read<AuthRepository>(), role),
          child: const LoginView(),
        );
      case register:
        final role = settings.arguments as UserRole? ?? UserRole.student;
        page = ChangeNotifierProvider(
          create: (c) => RegisterViewModel(c.read<AuthRepository>(), role),
          child: const RegisterView(),
        );
      case verifyEmail:
        page = ChangeNotifierProvider(
          create: (c) => EmailVerificationViewModel(c.read<AuthRepository>()),
          child: const EmailVerificationView(),
        );
      case forgotPassword:
        page = ChangeNotifierProvider(
          create: (c) => ForgotPasswordViewModel(c.read<AuthRepository>()),
          child: const ForgotPasswordView(),
        );
      case checkEmail:
        final email = settings.arguments as String? ?? '';
        page = ChangeNotifierProvider(
          create: (c) => ForgotPasswordViewModel(c.read<AuthRepository>(), initialEmail: email),
          child: const CheckEmailView(),
        );
      case home:
        page = ChangeNotifierProvider(
          create: (c) => HomeViewModel(c.read<AuthRepository>()),
          child: const HomeView(),
        );
      case splash:
      default:
        page = ChangeNotifierProvider(
          create: (c) => SplashViewModel(c.read<AuthRepository>()),
          child: const SplashView(),
        );
    }
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
