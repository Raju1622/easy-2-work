import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
            _Para(
              'Easy 2 Work ("we") respects your privacy. This policy describes how we collect, use and protect your information when you use our app.',
            ),
            _Para(
              'Information we collect: We collect information you provide when you register, book a service, or contact us — such as name, phone number, email, and address. We may also collect device and usage data to improve the app.',
            ),
            _Para(
              'How we use it: We use your information to process bookings, connect you with professionals, send updates, improve our services, and comply with legal requirements.',
            ),
            _Para(
              'Sharing: We may share your contact and address details with the professional assigned to your booking. We do not sell your personal data to third parties.',
            ),
            _Para(
              'Security: We use reasonable measures to protect your data. Payment details are processed through secure payment partners.',
            ),
            _Para(
              'Your rights: You can request access, correction or deletion of your data by contacting us. You may also opt out of marketing communications.',
            ),
            _Para(
              'Updates: We may update this policy. We will notify you of significant changes through the app or email.',
            ),
            _Para(
              'Contact: For privacy-related queries, write to us at privacy@easy2work.in.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Para extends StatelessWidget {
  const _Para(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(text, style: AppTheme.bodyStyle()),
    );
  }
}
