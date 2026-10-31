import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../viewmodels/forgot_password_viewmodel.dart';
import '../widgets/common.dart';
import '../widgets/primary_button.dart';

/// "Revisa tu correo": confirmación tras pedir el enlace de recuperación.
class CheckEmailView extends StatelessWidget {
  const CheckEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();
    final muted = AppText.labelSm.copyWith(color: AppColors.outline);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.6,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_user_outlined,
                              size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            'Portal Académico Seguro',
                            style: AppText.labelMd.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    child: Column(
                      children: [
                        const _MailBadge(),
                        const SizedBox(height: 24),
                        Text(
                          'Revisa tu correo',
                          style: AppText.headlineMd.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Si el correo está registrado, te enviamos un enlace para '
                          'restablecer tu contraseña institucional.',
                          textAlign: TextAlign.center,
                          style: AppText.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _ExpiryNote(),
                        const SizedBox(height: 32),
                        PrimaryButton.dark(
                          label: 'Volver a iniciar sesión',
                          leadingIcon: Icons.login,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 16),
                        TextLink(
                          label: vm.resendLabel,
                          icon: Icons.sync,
                          onTap: vm.canResend ? vm.resend : null,
                        ),
                        if (vm.secondsLeft > 0)
                          Text.rich(
                            TextSpan(
                              text: 'Podrás reenviar en ',
                              children: [
                                TextSpan(
                                  text: '${vm.secondsLeft}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const TextSpan(text: 's'),
                              ],
                            ),
                            style: muted,
                          ),
                        if (vm.error != null) ...[
                          const SizedBox(height: 12),
                          ErrorBanner(vm.error!),
                        ],
                      ],
                    ),
                  ),
                  Opacity(
                    opacity: 0.7,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.school_outlined,
                                size: 14, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Asistly · Gestión de Asistencia Universitaria',
                                style: AppText.labelSm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('¿Problemas de acceso? Contacta a soporte técnico', style: muted),
                      ],
                    ),
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

class _MailBadge extends StatefulWidget {
  const _MailBadge();

  @override
  State<_MailBadge> createState() => _MailBadgeState();
}

class _MailBadgeState extends State<_MailBadge> with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          FadeTransition(
            opacity: Tween<double>(begin: 0.4, end: 1).animate(_controller),
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.secondaryFixed.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.secondaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read, size: 44, color: AppColors.primaryContainer),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryNote extends StatelessWidget {
  const _ExpiryNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.secondaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.schedule, size: 18, color: AppColors.primaryContainer),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Validez temporal',
                  style: AppText.labelMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'El enlace vence en 1 hora. Si no lo ves en tu bandeja principal, '
                  'revisa la carpeta de spam o correo no deseado.',
                  style: AppText.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
