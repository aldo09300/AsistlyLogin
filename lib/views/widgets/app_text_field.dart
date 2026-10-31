import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Campo con etiqueta superior e ícono, estilo "filled" del design system.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.obscureText = false,
    this.onToggleObscure,
    this.showRequiredMark = false,
    this.labelColor = AppColors.primary,
    this.iconColor = AppColors.onSurfaceVariant,
    this.fillColor = AppColors.surfaceContainer,
    this.radius = 12,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;

  /// Si no es null, muestra el botón de ver/ocultar contraseña.
  final VoidCallback? onToggleObscure;
  final bool showRequiredMark;
  final Color labelColor;
  final Color iconColor;
  final Color fillColor;
  final double radius;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            children: [
              if (showRequiredMark)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.tertiaryContainer, fontWeight: FontWeight.w700),
                ),
            ],
          ),
          style: AppText.labelLg.copyWith(color: labelColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          style: AppText.bodyLg.copyWith(color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppText.bodyLg.copyWith(color: AppColors.outline),
            filled: true,
            // Se aclara al enfocar, como en el diseño.
            fillColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? AppColors.surfaceContainerLowest
                  : fillColor,
            ),
            prefixIcon: Icon(icon, size: 20, color: iconColor),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    onPressed: onToggleObscure,
                    tooltip: obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 20,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: AppColors.primaryContainer, width: 1.5),
            ),
            errorBorder: border.copyWith(borderSide: const BorderSide(color: AppColors.error)),
            focusedErrorBorder:
                border.copyWith(borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
            errorStyle: AppText.bodySm.copyWith(color: AppColors.error),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
