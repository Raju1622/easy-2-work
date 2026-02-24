import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        'Select services',
        'Browse electrical, AC, cleaning, repairs and more. Add to cart.',
      ),
      (
        'Choose time & pay',
        'Pick instant or schedule a slot. Add address and pay via UPI, card or COD.',
      ),
      (
        'Engineer on the way',
        'Track live. Get ETA. Our professional reaches your doorstep.',
      ),
      (
        'Service done',
        "Job completed. Rate your experience and we're here for your next booking.",
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'How It Works',
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
          children: [
            for (var i = 0; i < steps.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].$1,
                          style: AppTheme.subheadingStyle()
                              .copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          steps[i].$2,
                          style: AppTheme.bodyStyle(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (i < steps.length - 1)
                const Padding(
                  padding: EdgeInsets.only(
                      left: 19, top: 8, bottom: 8),
                  child: SizedBox(
                    width: 2,
                    height: 24,
                    child: ColoredBox(
                      color: AppTheme.border,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
