import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';

class AsistlyApp extends StatelessWidget {
  const AsistlyApp({super.key, this.authRepository});

  /// Permite inyectar un repositorio falso en pruebas.
  final AuthRepository? authRepository;

  @override
  Widget build(BuildContext context) {
    return Provider<AuthRepository>(
      create: (_) => authRepository ?? AuthRepository(),
      child: MaterialApp(
        title: 'Asistly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
