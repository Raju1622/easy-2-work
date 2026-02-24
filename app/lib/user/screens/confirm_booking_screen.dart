import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/user_address_provider.dart';
import 'payment_screen.dart';

/// Confirm Booking – order summary, address (from Profile), date & time, Proceed to payment
class ConfirmBookingScreen extends StatelessWidget {
  const ConfirmBookingScreen({super.key, this.instant = true});

  final bool instant;

  @override
  Widget build(BuildContext context) {
    final dateStr = instant ? 'Today' : 'Tomorrow';
    final timeStr =
        instant ? 'Instant ~10 mins' : '10:00 AM - 12:00 PM';

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Confirm booking',
          style: AppTheme.subheadingStyle().copyWith(fontSize: 18),
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
      body: Consumer2<CartProvider, UserAddressProvider>(
        builder: (context, cart, addressProvider, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }
          final savedAddress = addressProvider.address;
          final hasAddress = addressProvider.hasAddress;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionTitle(title: 'Order summary'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration().copyWith(
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      ...cart.items.map(
                        (item) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Text(
                                item.service.emoji,
                                style:
                                    const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '${item.service.name} × ${item.quantity}',
                                  style: AppTheme.bodyStyle()
                                      .copyWith(
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '₹${item.total.toStringAsFixed(0)}',
                                style: AppTheme.subheadingStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: AppTheme.subheadingStyle(),
                          ),
                          Text(
                            '₹${cart.totalAmount.toStringAsFixed(0)}',
                            style: AppTheme.headingStyle()
                                .copyWith(
                              color: AppTheme.primary,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                _SectionTitle(title: 'Address'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration().copyWith(
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasAddress ? 'Service address' : 'No address',
                              style: AppTheme.subheadingStyle()
                                  .copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hasAddress
                                  ? savedAddress
                                  : 'Add address in Profile – worker will see it for this booking',
                              style: AppTheme.captionStyle().copyWith(
                                fontStyle: hasAddress
                                    ? FontStyle.normal
                                    : FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right,
                          color: AppTheme.textSecondary),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _SectionTitle(title: 'Date & Time'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration().copyWith(
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          color: AppTheme.primary, size: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '$dateStr • $timeStr',
                          style: AppTheme.bodyStyle().copyWith(
                              color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: hasAddress
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  address: savedAddress,
                                  date: dateStr,
                                  timeSlot: timeStr,
                                ),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please add your address in Profile first. Worker will visit this address.'),
                                behavior: SnackBarBehavior.floating,
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
                      hasAddress
                          ? 'Proceed to payment'
                          : 'Add address in Profile first',
                      style: AppTheme.buttonStyle(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          AppTheme.subheadingStyle().copyWith(fontSize: 15),
    );
  }
}
