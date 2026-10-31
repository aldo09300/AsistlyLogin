import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_config.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../viewmodels/splash_viewmodel.dart';
import '../widgets/asistly_logo.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late final _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
    ..repeat();
  late final _progress =
      AnimationController(vsync: this, duration: SplashViewModel.minDuration)..forward();

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final destination = await context.read<SplashViewModel>().resolveStart();
    if (!mounted) return;
    final route = switch (destination) {
      AuthDestination.home => AppRoutes.home,
      AuthDestination.verifyEmail => AppRoutes.verifyEmail,
      AuthDestination.roleSelection => AppRoutes.roleSelection,
    };
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryContainer],
            ),
          ),
          child: Stack(
            children: [
              // Orbes de luz ambiental.
              const Positioned(
                top: -96,
                left: -80,
                child: _GlowOrb(size: 320, color: AppColors.secondaryContainer),
              ),
              const Positioned(
                bottom: -112,
                right: -80,
                child: _GlowOrb(size: 384, color: AppColors.tertiaryFixedDim),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(child: Center(child: _Branding(pulse: _pulse))),
                      _ProgressBar(progress: _progress),
                      const SizedBox(height: 28),
                    ],
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

class _Branding extends StatelessWidget {
  const _Branding({required this.pulse});

  final Animation<double> pulse;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 10)),
            ],
          ),
          alignment: Alignment.center,
          child: AsistlyGlyph(size: 80, pulse: pulse),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Asistly', style: AppText.displayLg.copyWith(color: AppColors.onPrimary)),
            const SizedBox(width: 4),
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: const BoxDecoration(
                color: AppColors.tertiaryFixedDim,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Tu asistencia, verificada',
          style: AppText.bodyLg.copyWith(color: AppColors.secondaryFixed, letterSpacing: 0.4),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user, size: 18, color: AppColors.tertiaryFixed),
              const SizedBox(width: 6),
              Text(
                AppConfig.universityName,
                style: AppText.labelSm.copyWith(color: AppColors.surface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 192,
        height: 4,
        child: AnimatedBuilder(
          animation: progress,
          builder: (_, _) => LinearProgressIndicator(
            value: Curves.easeInOut.transform(progress.value),
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            color: AppColors.tertiaryFixedDim,
          ),
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
