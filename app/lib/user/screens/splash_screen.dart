import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';
import '../../worker/worker_shell.dart';

/// Splash – logo, tagline, 2–3 sec then redirect (auth check → Login / User / Worker)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final roleIndex = prefs.getInt(AuthProvider.keyRole);
    if (roleIndex != null && roleIndex >= 0 && roleIndex < AuthRole.values.length) {
      final role = AuthRole.values[roleIndex];
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => role == AuthRole.user
              ? const MainShell()
              : const WorkerShell(),
        ),
      );
      return;
    }
    final seen = await OnboardingScreen.hasSeenOnboarding();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            seen ? const LoginScreen() : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D9488),
              Color(0xFF0F766E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_repair_service_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              )
                  .animate()
                  .scale(
                      delay: 200.ms, duration: 500.ms, curve: Curves.easeOut)
                  .fadeIn(duration: 400.ms),
              const SizedBox(height: 28),
              Text(
                'Easy 2 Work',
                style: AppTheme.headingStyle().copyWith(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 400.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 12),
              Text(
                "India's Quick Home Service App",
                style: AppTheme.bodyStyle().copyWith(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.95),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 400.ms),
              const Spacer(flex: 2),
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
