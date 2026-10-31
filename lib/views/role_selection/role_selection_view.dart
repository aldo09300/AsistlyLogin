import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/user_role.dart';
import '../../viewmodels/role_selection_viewmodel.dart';
import '../widgets/primary_button.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoleSelectionViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
                      ],
                    ),
                    child: const Icon(Icons.school, size: 24, color: AppColors.tertiaryFixedDim),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Asistly',
                    style: AppText.titleLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                '¿Cómo vas a usar Asistly?',
                textAlign: TextAlign.center,
                style: AppText.headlineMd.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.assignment_ind,
                title: 'Soy docente',
                subtitle: 'Crea clases y controla la asistencia',
                selected: vm.selected == UserRole.teacher,
                onTap: () => vm.select(UserRole.teacher),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.person_outline,
                title: 'Soy estudiante',
                subtitle: 'Registra tu asistencia en clase',
                selected: vm.selected == UserRole.student,
                onTap: () => vm.select(UserRole.student),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                label: 'Continuar',
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.login,
                  arguments: vm.selected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryFixed : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryContainer : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? 0.12 : 0.05),
              blurRadius: selected ? 10 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.surfaceContainerLowest : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 26, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.titleMd.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppText.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryContainer
                          : AppColors.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: selected ? 1 : 0,
                      child: const Icon(Icons.check, size: 16, color: AppColors.surface),
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
