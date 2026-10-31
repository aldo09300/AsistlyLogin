import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../data/models/user_role.dart';
import '../../viewmodels/register_viewmodel.dart';
import '../widgets/app_text_field.dart';
import '../widgets/common.dart';
import '../widgets/primary_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _code, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final vm = context.read<RegisterViewModel>();
    final formOk = _formKey.currentState!.validate();
    if (!formOk) return;

    final ok = await vm.register(
      fullName: _name.text,
      code: _code.text,
      email: _email.text,
      password: _password.text,
    );
    if (!mounted || !ok) return;
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.verifyEmail, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();
    const fieldStyle = (
      labelColor: AppColors.onSurface,
      iconColor: AppColors.secondary,
      radius: 16.0,
    );

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
                  const Align(alignment: Alignment.centerLeft, child: CircleBackButton()),
                  const SizedBox(height: 16),
                  Text(
                    'Crear cuenta',
                    style: AppText.headlineLg.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vm.role == UserRole.student
                        ? 'Ingresa tus datos institucionales para crear tu cuenta.'
                        : 'Ingresa tus datos institucionales para crear tu cuenta de docente.',
                    style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 20),
                  if (vm.bindsDevice) ...[
                    const _DeviceNotice(),
                    const SizedBox(height: 24),
                  ],
                  AppTextField(
                    controller: _name,
                    label: 'Nombre completo',
                    hint: 'Ej. Valeria Gómez Morales',
                    icon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                    autofillHints: const [AutofillHints.name],
                    validator: Validators.fullName,
                    labelColor: fieldStyle.labelColor,
                    iconColor: fieldStyle.iconColor,
                    radius: fieldStyle.radius,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _code,
                    label: vm.codeLabel,
                    hint: 'Ej. 2024-10842',
                    icon: Icons.badge_outlined,
                    validator: Validators.institutionalCode,
                    labelColor: fieldStyle.labelColor,
                    iconColor: fieldStyle.iconColor,
                    radius: fieldStyle.radius,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _email,
                    label: 'Correo institucional',
                    hint: 'nombre.apellido@udla.edu.co',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: Validators.institutionalEmail,
                    labelColor: fieldStyle.labelColor,
                    iconColor: fieldStyle.iconColor,
                    radius: fieldStyle.radius,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _password,
                    label: 'Contraseña',
                    hint: 'Mínimo 8 caracteres',
                    icon: Icons.lock_outline,
                    obscureText: vm.obscurePassword,
                    onToggleObscure: vm.togglePasswordVisibility,
                    autofillHints: const [AutofillHints.newPassword],
                    validator: Validators.newPassword,
                    labelColor: fieldStyle.labelColor,
                    iconColor: fieldStyle.iconColor,
                    radius: fieldStyle.radius,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: _confirm,
                    label: 'Confirmar contraseña',
                    hint: 'Repite tu contraseña',
                    icon: Icons.lock_reset,
                    obscureText: vm.obscureConfirm,
                    onToggleObscure: vm.toggleConfirmVisibility,
                    textInputAction: TextInputAction.done,
                    validator: (v) => Validators.confirmPassword(v, _password.text),
                    labelColor: fieldStyle.labelColor,
                    iconColor: fieldStyle.iconColor,
                    radius: fieldStyle.radius,
                  ),
                  const SizedBox(height: 12),
                  _TermsCheckbox(
                    value: vm.acceptedTerms,
                    onChanged: vm.isLoading ? null : vm.setAcceptedTerms,
                  ),
                  if (vm.error != null) ...[
                    const SizedBox(height: 12),
                    ErrorBanner(vm.error!),
                  ],
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Registrarme',
                    trailingIcon: Icons.arrow_forward,
                    radius: 16,
                    isLoading: vm.isLoading,
                    onPressed: _submit,
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

class _DeviceNotice extends StatelessWidget {
  const _DeviceNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondaryFixed.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.phonelink_lock, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dispositivo seguro',
                  style: AppText.titleMd.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tu cuenta quedará vinculada a este dispositivo. '
                  'Solo podrás registrar asistencia desde este celular.',
                  style: AppText.bodySm.copyWith(
                    color: AppColors.onSecondaryFixedVariant,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value,
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: value ? AppColors.primaryContainer : AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: value
                    ? const Icon(Icons.check, size: 18, color: AppColors.onPrimary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    'Acepto los términos y el tratamiento de datos',
                    style: AppText.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
