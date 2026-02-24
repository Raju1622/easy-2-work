import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/nav_provider.dart';
import 'all_services_screen.dart';
import 'book_service_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Main shell with bottom navigation: Home, Services, Cart, Profile
class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavProvider, CartProvider>(
      builder: (context, nav, cart, _) {
        return Scaffold(
          body: IndexedStack(
            index: nav.index,
            children: const [
              HomeScreen(),
              AllServicesScreen(),
              BookServiceScreen(),
              ProfileScreen(),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 24,
                  offset: const Offset(0, -4),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected: nav.index == 0,
                      onTap: () => nav.setIndex(0),
                    ),
                    _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Services',
                      selected: nav.index == 1,
                      onTap: () => nav.setIndex(1),
                    ),
                    _NavItem(
                      icon: Icons.shopping_cart_rounded,
                      label: 'Cart',
                      selected: nav.index == 2,
                      badge: cart.itemCount > 0 ? cart.itemCount : null,
                      onTap: () => nav.setIndex(2),
                    ),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      selected: nav.index == 3,
                      onTap: () => nav.setIndex(3),
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
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final int? badge;
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
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    size: 24,
                    color: selected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                  if (badge != null && badge! > 0)
                    Positioned(
                      right: -6,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        constraints: const BoxConstraints(
                            minWidth: 18, minHeight: 18),
                        decoration: BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accent.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.captionStyle().copyWith(
                  fontSize: 11,
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
