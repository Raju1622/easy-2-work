import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../core/models/booking_model.dart';
import 'track_screen.dart';

/// Booking Confirmed – Booking ID, service, time slot, Track Engineer
class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key, required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppTheme.success.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  size: 80,
                  color: AppTheme.success,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Booking Confirmed!',
                style:
                    AppTheme.headingStyle().copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Booking ID: ${booking.id}',
                style: AppTheme.bodyStyle().copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.cardDecoration().copyWith(
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Row(
                        label: 'Service',
                        value: booking.serviceNames),
                    const SizedBox(height: 12),
                    _Row(
                        label: 'Time slot',
                        value:
                            '${booking.date} • ${booking.timeSlot}'),
                    const SizedBox(height: 12),
                    _Row(label: 'Address', value: booking.address),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            TrackScreen(booking: booking),
                      ),
                    );
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
                    'Track Engineer',
                    style: AppTheme.buttonStyle(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .popUntil((r) => r.isFirst),
                child: Text(
                  'Back to Home',
                  style: AppTheme.bodyStyle().copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.captionStyle()),
        const SizedBox(height: 4),
        Text(value,
            style: AppTheme.bodyStyle()
                .copyWith(color: AppTheme.textPrimary)),
      ],
    );
  }
}
