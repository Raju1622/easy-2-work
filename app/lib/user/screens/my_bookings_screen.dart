import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/models/booking_model.dart';
import '../../core/providers/bookings_provider.dart';
import 'track_screen.dart';
import 'review_screen.dart';

/// My Bookings – tabs: Active, Completed, Cancelled
class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppTheme.bgLight,
        appBar: AppBar(
          title: Text(
            'My Bookings',
            style:
                AppTheme.subheadingStyle().copyWith(fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppTheme.textPrimary,
          bottom: TabBar(
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primary,
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: Consumer<BookingsProvider>(
          builder: (context, provider, _) {
            return TabBarView(
              children: [
                _BookingList(
                  list: provider.active,
                  emptyMessage: 'No active bookings',
                  onTap: (b) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TrackScreen(booking: b),
                    ),
                  ),
                  showTrack: true,
                ),
                _BookingList(
                  list: provider.completed,
                  emptyMessage: 'No completed bookings',
                  onTap: (b) {
                    if (b.canReview) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReviewScreen(booking: b),
                        ),
                      );
                    }
                  },
                  showTrack: false,
                ),
                _BookingList(
                  list: provider.cancelled,
                  emptyMessage: 'No cancelled bookings',
                  onTap: null,
                  showTrack: false,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({
    required this.list,
    required this.emptyMessage,
    this.onTap,
    required this.showTrack,
  });

  final List<BookingModel> list;
  final String emptyMessage;
  final void Function(BookingModel)? onTap;
  final bool showTrack;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 64,
              color:
                  AppTheme.textSecondary.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: AppTheme.bodyStyle(),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final b = list[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  onTap != null ? () => onTap!(b) : null,
              borderRadius:
                  BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration:
                    AppTheme.cardDecoration().copyWith(
                  border:
                      Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          b.id,
                          style: AppTheme.captionStyle()
                              .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        Text(
                          '₹${b.totalAmount.toStringAsFixed(0)}',
                          style: AppTheme.subheadingStyle()
                              .copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      b.serviceNames,
                      style: AppTheme.subheadingStyle()
                          .copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${b.date} • ${b.timeSlot}',
                      style: AppTheme.captionStyle(),
                    ),
                    if (showTrack &&
                        b.status ==
                            BookingStatus.active) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => onTap!(b),
                          icon: const Icon(
                              Icons.location_on_rounded,
                              size: 18),
                          label: const Text('Track'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
