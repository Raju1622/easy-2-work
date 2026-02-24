import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_theme.dart';
import 'login_screen.dart';

const String _keyOnboardingSeen = 'onboarding_seen';

/// Onboarding – 3 slides + Get Started
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingSeen) ?? false;
  }

  static Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingSeen, true);
  }

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<({String title, String subtitle, IconData icon})>
      _slides = [
    (
      title: 'Book services instantly',
      subtitle:
          'Choose from electrical, AC, cleaning & more. Add to cart and book in minutes.',
      icon: Icons.flash_on_rounded,
    ),
    (
      title: 'Verified professionals',
      subtitle:
          'Skilled, background-checked experts. Safe and reliable service at your doorstep.',
      icon: Icons.verified_user_rounded,
    ),
    (
      title: 'Track engineer live',
      subtitle:
          'See real-time location and ETA. Call your engineer anytime.',
      icon: Icons.location_on_rounded,
    ),
  ];

  Future<void> _getStarted() async {
    await OnboardingScreen.setOnboardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: _currentPage < _slides.length - 1
                  ? TextButton(
                      onPressed: () => _pageController.animateToPage(
                        _slides.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(
                        'Skip',
                        style: AppTheme.bodyStyle().copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : const SizedBox(height: 48),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primary.withOpacity(0.15),
                                AppTheme.primary.withOpacity(0.06),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide.icon,
                            size: 80,
                            color: AppTheme.primary,
                          ),
                        )
                            .animate()
                            .scale(
                                delay: 100.ms,
                                duration: 400.ms,
                                curve: Curves.easeOut)
                            .fadeIn(),
                        const SizedBox(height: 48),
                        Text(
                          slide.title,
                          style: AppTheme.headingStyle()
                              .copyWith(fontSize: 26),
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(
                                begin: 0.1, end: 0, curve: Curves.easeOut),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          style: AppTheme.bodyStyle().copyWith(
                            fontSize: 15,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate()
                            .fadeIn(delay: 300.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          _currentPage == i ? AppTheme.primary : AppTheme.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _currentPage == _slides.length - 1
                      ? _getStarted
                      : () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: AppTheme.buttonStyle(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
