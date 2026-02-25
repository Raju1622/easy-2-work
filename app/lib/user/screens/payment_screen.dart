import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/models/booking_model.dart';
import '../../core/models/cart_item.dart';
import '../../core/providers/bookings_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/nav_provider.dart';
import 'booking_confirmed_screen.dart';

/// Payment – Cash on Payment only → then Booking Confirmed
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
    required this.address,
    required this.date,
    required this.timeSlot,
    this.latitude,
    this.longitude,
  });

  final String address;
  final String date;
  final String timeSlot;
  final double? latitude;
  final double? longitude;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void _pay() {
    final cart = context.read<CartProvider>();
    final bookings = context.read<BookingsProvider>();
    final items =
        List<CartItem>.from(cart.items.map((e) => CartItem(
              service: e.service,
              quantity: e.quantity,
            )));
    final total = cart.totalAmount;
    final booking = BookingModel(
      id: 'E2W${DateTime.now().millisecondsSinceEpoch}',
      items: items,
      totalAmount: total,
      address: widget.address,
      date: widget.date,
      timeSlot: widget.timeSlot,
      createdAt: DateTime.now(),
      engineerPhone: null,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );
    bookings.addBooking(booking);
    cart.clearCart();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => BookingConfirmedScreen(booking: booking),
      ),
      (route) => route.isFirst,
    );
    context.read<NavProvider>().setIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Payment',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Payment',
                    style: AppTheme.subheadingStyle(),
                  ),
                  const SizedBox(height: 16),
                  _Option(
                    icon: Icons.money_rounded,
                    title: 'Cash on Payment',
                    subtitle: 'Pay when service is done',
                    value: 'cod',
                    selected: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _pay,
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
                    'Pay & confirm booking',
                    style: AppTheme.buttonStyle(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withOpacity(0.08)
                : AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? AppTheme.primary
                  : AppTheme.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon,
                  size: 28,
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.textSecondary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTheme.subheadingStyle()
                            .copyWith(fontSize: 15)),
                    Text(subtitle,
                        style: AppTheme.captionStyle()),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded,
                    color: AppTheme.primary, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
