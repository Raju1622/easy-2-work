import 'package:flutter/material.dart';

import '../../core/app_theme.dart';

enum AppBarStyle { gradient, white }

class GradientAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = true,
    this.style = AppBarStyle.gradient,
  });

  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final AppBarStyle style;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (style == AppBarStyle.white) {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppBar(
          title: Text(
            title,
            style: AppTheme.subheadingStyle().copyWith(fontSize: 18),
          ),
          centerTitle: centerTitle,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: AppTheme.textPrimary,
          surfaceTintColor: Colors.transparent,
          iconTheme: const IconThemeData(color: AppTheme.textPrimary, size: 22),
          actionsIconTheme: const IconThemeData(color: AppTheme.textPrimary, size: 24),
          actions: actions,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.appBarGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: AppTheme.headingStyle().copyWith(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white, size: 22),
        actionsIconTheme: const IconThemeData(color: Colors.white, size: 24),
        actions: actions,
      ),
    );
  }
}
