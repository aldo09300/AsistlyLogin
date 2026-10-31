import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/email_verification_viewmodel.dart';
import '../widgets/common.dart';
import '../widgets/primary_button.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  late final EmailVerificationViewModel _vm;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _vm = context.read<EmailVerificationViewModel>()..addListener(_onVmChanged);
  }

  /// Efectos de una sola vez: navegar al verificar y mostrar mensajes.
  void _onVmChanged() {
    if (!mounted) return;
    if (_vm.isVerified && !_navigated) {
      _navigated = true;
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
      return;
    }
    final message = _vm.message;
    if (message != null) {
      _vm.consumeMessage();
      showAppSnackBar(context, message);
    }
  }

  Future<void> _useAnotherAccount() async {
    await _vm.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.roleSelection, (_) => false);
  }

  @override
  void dispose() {
    _vm.removeListener(_onVmChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EmailVerificationViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1)),
                  ],
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mail_outline, size: 30, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verifica tu correo',
                textAlign: TextAlign.center,
                style: AppText.headlineMd.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Text(
                'Te enviamos un enlace de verificación a',
                textAlign: TextAlign.center,
                style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                vm.maskedEmail,
                textAlign: TextAlign.center,
                style: AppText.headlineSm.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondaryFixed),
                ),
                child: const Column(
                  children: [
                    _Step(number: 1, bold: 'Abre', rest: ' tu correo institucional'),
                    SizedBox(height: 14),
                    _Step(number: 2, bold: 'Toca', rest: ' el enlace de verificación'),
                    SizedBox(height: 14),
                    _Step(number: 3, bold: 'Vuelve a Asistly', rest: ' y continúa'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Ya verifiqué mi correo',
                height: 56,
                radius: 16,
                isLoading: vm.isChecking,
                onPressed: vm.checkNow,
              ),
              const SizedBox(height: 20),
              if (vm.canResend)
                TextLink(
                  label: 'Reenviar correo',
                  icon: Icons.sync,
                  onTap: vm.resend,
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text.rich(
                        TextSpan(
                          text: 'Reenviar correo · disponible en ',
                          children: [
                            TextSpan(
                              text: vm.countdownLabel,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              TextLink(
                label: 'Usar otra cuenta',
                style: AppText.labelMd.copyWith(color: AppColors.outline),
                onTap: _useAnotherAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.bold, required this.rest});

  final int number;
  final String bold;
  final String rest;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: AppText.labelMd.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: bold,
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: rest),
                ],
              ),
              style: AppText.bodyMd.copyWith(color: AppColors.onSurface),
            ),
          ),
        ),
      ],
    );
  }
}
