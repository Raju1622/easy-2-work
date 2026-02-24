import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/providers/nav_provider.dart';
import 'worker_jobs_screen.dart';
import 'worker_my_jobs_screen.dart';
import 'worker_profile_screen.dart';

/// Worker app shell – Jobs, My Jobs, Profile
class WorkerShell extends StatelessWidget {
  const WorkerShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavProvider>(
      builder: (context, nav, _) {
        // Worker has 3 tabs (0–2); clamp in case NavProvider had index from user shell (e.g. 3)
        const workerTabCount = 3;
        final safeIndex = nav.index.clamp(0, workerTabCount - 1);
        return Scaffold(
          body: IndexedStack(
            index: safeIndex,
            children: const [
              WorkerJobsScreen(),
              WorkerMyJobsScreen(),
              WorkerProfileScreen(),
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
                      icon: Icons.work_rounded,
                      label: 'Jobs',
                      selected: safeIndex == 0,
                      onTap: () => nav.setIndex(0),
                    ),
                    _NavItem(
                      icon: Icons.assignment_rounded,
                      label: 'My Jobs',
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
              Icon(
                icon,
                size: 24,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
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
