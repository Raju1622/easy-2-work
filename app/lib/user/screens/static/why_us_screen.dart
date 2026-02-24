import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class WhyUsScreen extends StatelessWidget {
  const WhyUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Why Us',
          style:
              AppTheme.subheadingStyle().copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Point(
              icon: Icons.verified_user_rounded,
              title: 'Verified professionals',
              body:
                  'Every technician is background-checked and trained. Safe, skilled help at your doorstep.',
            ),
            _Point(
              icon: Icons.schedule_rounded,
              title: 'Book instantly or schedule',
              body:
                  'Need help now? Choose instant booking. Or pick a date and time that works for you.',
            ),
            _Point(
              icon: Icons.price_change_rounded,
              title: 'Transparent pricing',
              body:
                  'See prices before you book. No hidden charges. Pay only for what you order.',
            ),
            _Point(
              icon: Icons.location_on_rounded,
              title: 'Live tracking',
              body:
                  'Track your engineer in real time. Know exactly when they will arrive.',
            ),
            _Point(
              icon: Icons.support_agent_rounded,
              title: 'Support when you need it',
              body:
                  'Our team is here to help. Call or chat for any issue with your booking.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.subheadingStyle()
                      .copyWith(fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(body, style: AppTheme.bodyStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
