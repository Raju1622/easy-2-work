import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../../core/models/service_model.dart';

class ServicesInfoScreen extends StatelessWidget {
  const ServicesInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Services',
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
        itemCount: allServices.length,
        itemBuilder: (context, index) {
          final s = allServices[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: AppTheme.cardDecoration().copyWith(
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  Text(s.emoji,
                      style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: AppTheme.subheadingStyle()
                              .copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          s.description,
                          style: AppTheme.captionStyle(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${s.basePrice.toInt()}+',
                    style: AppTheme.subheadingStyle()
                        .copyWith(color: AppTheme.primary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
