import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    (
      'How do I book a service?',
      'Open the app, choose a service (e.g. Electrical, AC, Cleaning), add to cart, select date/time and address, then pay. You can book instantly or schedule for later.',
    ),
    (
      'What payment options are available?',
      'We accept UPI (GPay, PhonePe, Paytm), credit/debit cards, and Cash on Delivery (COD) when the professional completes the job.',
    ),
    (
      'Can I track the engineer?',
      'Yes. After booking, you can track the engineer on the way with live location and ETA. You can also call the engineer from the app.',
    ),
    (
      'Are your professionals verified?',
      'Yes. All technicians are background-checked and trained. We ensure safe, quality service at your home.',
    ),
    (
      'What if I need to cancel?',
      'You can cancel from My Bookings. Cancellation policy may apply depending on how close to the slot you cancel.',
    ),
    (
      'Which cities do you serve?',
      'We currently serve Varanasi and are expanding to more cities. Check the app for availability in your area.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'FAQs',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _faqs.length,
        itemBuilder: (context, index) {
          final q = _faqs[index].$1;
          final a = _faqs[index].$2;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: AppTheme.cardDecoration().copyWith(
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q,
                    style: AppTheme.subheadingStyle()
                        .copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text(a, style: AppTheme.bodyStyle()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
