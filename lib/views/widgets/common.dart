import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Botón circular "volver" del diseño.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainer,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed ?? () => Navigator.of(context).maybePop(),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.arrow_back, size: 20, color: AppColors.primary),
        ),
      ),
    );
  }
}

/// Banner de error dentro de los formularios.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, size: 20, color: AppColors.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppText.bodyMd.copyWith(color: AppColors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// Enlace de texto (ej. "¿Olvidaste tu contraseña?").
class TextLink extends StatelessWidget {
  const TextLink({super.key, required this.label, required this.onTap, this.icon, this.style});

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        AppText.labelLg.copyWith(
          color: onTap == null ? AppColors.outline : AppColors.primaryContainer,
          fontWeight: FontWeight.w600,
        );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: textStyle.color),
              const SizedBox(width: 6),
            ],
            Flexible(child: Text(label, style: textStyle)),
          ],
        ),
      ),
    );
  }
}

void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
