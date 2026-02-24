import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
              'Welcome to Easy 2 Work. By using our app and services, you agree to these Terms & Conditions.',
            ),
            _Para(
              '1. Service booking: You book home services (electrical, AC, cleaning, repairs, etc.) through the app. Prices shown are indicative; final cost may vary based on scope of work.',
            ),
            _Para(
              '2. Payment: You agree to pay the amount due via the chosen method (UPI, card, or COD). For COD, payment is made when the professional completes the service.',
            ),
            _Para(
              '3. Cancellation: You may cancel a booking as per our cancellation policy. Refunds, if applicable, will be processed as per our policy.',
            ),
            _Para(
              '4. Conduct: You agree to provide a safe environment for our professionals and to use the service only for lawful purposes.',
            ),
            _Para(
              '5. Liability: Easy 2 Work facilitates booking; the actual service is provided by verified third-party professionals. We are not liable for any damage or loss beyond what is covered under our policy.',
            ),
            _Para(
              '6. Changes: We may update these terms. Continued use of the app after changes constitutes acceptance.',
            ),
            _Para(
              'For questions, contact us at support@easy2work.in.',
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
