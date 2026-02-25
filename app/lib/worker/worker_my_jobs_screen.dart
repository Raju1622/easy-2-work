import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_theme.dart';
import '../core/models/booking_model.dart';
import '../core/providers/bookings_provider.dart';
import '../core/providers/worker_jobs_provider.dart';
import '../shared/widgets/gradient_app_bar.dart';

/// Worker – jobs accepted by this worker
class WorkerMyJobsScreen extends StatelessWidget {
  const WorkerMyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: const GradientAppBar(
        title: 'My Jobs',
        style: AppBarStyle.gradient,
      ),
      body: Consumer2<BookingsProvider, WorkerJobsProvider>(
        builder: (context, bookings, workerJobs, _) {
          final myJobs = bookings.active
              .where((b) => workerJobs.acceptedBookingIds.contains(b.id))
              .toList();
          if (myJobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_rounded,
                    size: 64,
                    color: AppTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No accepted jobs',
                    style: AppTheme.subheadingStyle(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accept jobs from the Jobs tab',
                    style: AppTheme.bodyStyle(),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: myJobs.length,
            itemBuilder: (context, index) {
              final b = myJobs[index];
              return _MyJobCard(booking: b);
            },
          );
        },
      ),
    );
  }
}

class _MyJobCard extends StatelessWidget {
  const _MyJobCard({required this.booking});

  final BookingModel booking;

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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₹${booking.totalAmount.toStringAsFixed(0)}',
                      style: AppTheme.subheadingStyle().copyWith(
                        color: AppTheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Active',
                      style: AppTheme.captionStyle().copyWith(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Services',
            style: AppTheme.captionStyle().copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
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
                    Text('× ${item.quantity}', style: AppTheme.captionStyle()),
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
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final hasCoords = booking.latitude != null && booking.longitude != null;
                    final address = booking.address;
                    if (!hasCoords && address.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No address or location to navigate to'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                    final String url = hasCoords
                        ? 'https://www.google.com/maps?q=${booking.latitude},${booking.longitude}'
                        : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
                    final uri = Uri.parse(url);
                    try {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Could not open maps. Address: $address'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.directions_rounded, size: 18),
                  label: const Text('Navigate'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.read<BookingsProvider>().completeBooking(booking.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Job marked complete'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Done'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
