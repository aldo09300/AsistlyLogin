import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_role.dart';
import '../../data/repositories/auth_repository.dart';
import '../../viewmodels/login_viewmodel.dart';
import '../widgets/app_text_field.dart';
import '../widgets/common.dart';
import '../widgets/primary_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<LoginViewModel>();
    final destination = await vm.login(_email.text, _password.text);
    if (!mounted || destination == null) return;

    final route =
        destination == AuthDestination.home ? AppRoutes.home : AppRoutes.verifyEmail;
    Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
    final isStudent = vm.role == UserRole.student;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleBackButton(),
                      _RoleChip(role: vm.role),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _HeroCard(),
                  const SizedBox(height: 24),
                  Text(
                    'Iniciar sesión',
                    style: AppText.headlineMd.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isStudent
                        ? 'Ingresa tus credenciales oficiales para registrar tu asistencia hoy.'
                        : 'Ingresa tus credenciales oficiales para gestionar tus clases.',
                    style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _email,
                    label: 'Correo institucional',
                    hint: 'ejemplo@udla.edu.co',
                    icon: Icons.alternate_email,
                    showRequiredMark: true,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.institutionalEmail,
                    onChanged: (_) => vm.clearError(),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _password,
                    label: 'Contraseña',
                    hint: 'Ingresa tu clave de acceso',
                    icon: Icons.lock_outline,
                    showRequiredMark: true,
                    obscureText: vm.obscurePassword,
                    onToggleObscure: vm.togglePasswordVisibility,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    validator: Validators.loginPassword,
                    onChanged: (_) => vm.clearError(),
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextLink(
                      label: '¿Olvidaste tu contraseña?',
                      onTap: vm.isLoading
                          ? null
                          : () => Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                    ),
                  ),
                  if (vm.error != null) ...[
                    const SizedBox(height: 12),
                    ErrorBanner(vm.error!),
                  ],
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Ingresar',
                    trailingIcon: Icons.login,
                    isLoading: vm.isLoading,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      TextLink(
                        label: 'Regístrate',
                        style: AppText.labelLg.copyWith(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                        onTap: vm.isLoading
                            ? null
                            : () => Navigator.of(context)
                                .pushNamed(AppRoutes.register, arguments: vm.role),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            role == UserRole.student ? Icons.school : Icons.assignment_ind,
            size: 16,
            color: AppColors.primaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            role.label,
            style: AppText.labelMd.copyWith(
              color: AppColors.primaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 176,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/login_hero.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.85),
                    AppColors.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'CONTROL DE ASISTENCIA',
                          style: AppText.labelSm.copyWith(
                            color: AppColors.tertiaryFixed,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Campus Digital',
                          style: AppText.titleMd.copyWith(color: AppColors.surface),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user_outlined,
                        size: 20, color: AppColors.onPrimary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
