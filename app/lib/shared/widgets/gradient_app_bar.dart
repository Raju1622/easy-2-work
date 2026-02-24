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
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AppBar(
          title: Text(
            title,
            style:
                AppTheme.subheadingStyle().copyWith(fontSize: 18),
          ),
          centerTitle: centerTitle,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppTheme.textPrimary,
          iconTheme:
              const IconThemeData(color: AppTheme.textPrimary),
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
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: actions,
      ),
    );
  }
}
