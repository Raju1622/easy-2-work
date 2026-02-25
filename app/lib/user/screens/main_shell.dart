import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/providers/nav_provider.dart';
import 'all_services_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Main shell with bottom navigation: Home, Services, Profile (Cart icon on Home, opens cart flow)
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavProvider>(
      builder: (context, nav, _) {
        // 3 tabs: Home, Services, Profile (Cart removed from bar; use Home cart icon)
        const tabCount = 3;
        final safeIndex = nav.index.clamp(0, tabCount - 1);
        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: const [
              HomeScreen(),
              AllServicesScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected: safeIndex == 0,
                      onTap: () => nav.setIndex(0),
                    ),
                    _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Services',
                      selected: safeIndex == 1,
                      onTap: () => nav.setIndex(1),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      selected: safeIndex == 2,
                      onTap: () => nav.setIndex(2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        splashColor: AppTheme.primary.withOpacity(0.08),
        highlightColor: AppTheme.primary.withOpacity(0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 18 : 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 26,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTheme.captionStyle().copyWith(
                  fontSize: 12,
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
