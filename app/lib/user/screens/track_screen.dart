import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/models/booking_model.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/nav_provider.dart';

/// Live Tracking – Engineer on the way, map placeholder, ETA, Call Engineer
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key, this.booking, this.onBackToHome});

  final BookingModel? booking;
  final VoidCallback? onBackToHome;

  @override
  Widget build(BuildContext context) {
    const eta = '~15 mins';
    final phone = booking?.engineerPhone ?? '+91 98765 43210';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Track Engineer',
          style: AppTheme.subheadingStyle().copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            context.read<CartProvider>().clearCart();
            onBackToHome?.call();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: AppTheme.elevatedCard().copyWith(
                  color: AppTheme.success.withOpacity(0.08),
                  border: Border.all(
                      color: AppTheme.success.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.success.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delivery_dining_rounded,
                        size: 48,
                        color: AppTheme.success,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Engineer on the way',
                      style: AppTheme.headingStyle().copyWith(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ETA $eta',
                        style: AppTheme.buttonStyle().copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration:
                      AppTheme.cardDecoration().copyWith(
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 56,
                          color: AppTheme.textSecondary
                              .withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your address',
                          style: AppTheme.bodyStyle(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Map integration (e.g. Google Maps) can be added here',
                          style: AppTheme.captionStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text('Calling $phone'),
                        behavior:
                            SnackBarBehavior.floating,
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone_rounded,
                      size: 22),
                  label: const Text('Call Engineer'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: AppTheme.primary,
                        width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context
                        .read<CartProvider>()
                        .clearCart();
                    onBackToHome?.call();
                    Navigator.of(context)
                        .popUntil((r) => r.isFirst);
                    context.read<NavProvider>().setIndex(0);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Back to Home',
                    style: AppTheme.buttonStyle(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
