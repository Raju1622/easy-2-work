import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_theme.dart';
import '../core/models/booking_model.dart';
import '../core/providers/bookings_provider.dart';
import '../core/providers/worker_jobs_provider.dart';
import '../shared/widgets/gradient_app_bar.dart';

/// Worker – user ne jo service book ki hai wahi yahan "Available Jobs" mein dikhti hai
class WorkerJobsScreen extends StatelessWidget {
  const WorkerJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: const GradientAppBar(
        title: 'Available Jobs',
        style: AppBarStyle.gradient,
      ),
      body: Consumer2<BookingsProvider, WorkerJobsProvider>(
        builder: (context, bookings, workerJobs, _) {
          // User ki active bookings jo is worker ne accept nahi ki
          final available = bookings.active
              .where((b) => !workerJobs.acceptedBookingIds.contains(b.id))
              .toList();
          if (available.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.work_off_rounded,
                      size: 64,
                      color: AppTheme.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No new jobs right now',
                      style: AppTheme.subheadingStyle(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'When customers book a service, it will appear here. Check back later.',
                      style: AppTheme.bodyStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: available.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Customer bookings – accept to add to My Jobs',
                    style: AppTheme.captionStyle().copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                );
              }
              final b = available[index - 1];
              return _JobCard(
                booking: b,
                onAccept: () {
                  workerJobs.acceptJob(b.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Job ${b.id} accepted'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppTheme.success,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  const _JobCard({required this.booking, required this.onAccept});

  final BookingModel booking;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration().copyWith(
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Booking ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking ${booking.id}',
                style: AppTheme.captionStyle().copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '₹${booking.totalAmount.toStringAsFixed(0)}',
                  style: AppTheme.subheadingStyle().copyWith(
                    color: AppTheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Services booked
          Text(
            'Services',
            style: AppTheme.captionStyle().copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          ...booking.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ${item.service.name}',
                      style: AppTheme.bodyStyle().copyWith(fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '× ${item.quantity}',
                      style: AppTheme.captionStyle(),
                    ),
                    const Spacer(),
                    Text(
                      '₹${item.total.toStringAsFixed(0)}',
                      style: AppTheme.captionStyle().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address',
                      style: AppTheme.captionStyle().copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.address,
                      style: AppTheme.bodyStyle().copyWith(fontSize: 14),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Date & time
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                booking.date,
                style: AppTheme.bodyStyle().copyWith(fontSize: 14),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time_rounded,
                  size: 16, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                booking.timeSlot,
                style: AppTheme.bodyStyle().copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
              ),
              child: const Text('Accept Job'),
            ),
          ),
        ],
      ),
    );
  }
}
