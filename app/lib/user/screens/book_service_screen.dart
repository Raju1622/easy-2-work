import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/models/cart_item.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/nav_provider.dart';
import '../../shared/widgets/gradient_app_bar.dart';
import 'confirm_booking_screen.dart';

/// Book Service / Cart
class BookServiceScreen extends StatefulWidget {
  const BookServiceScreen({super.key});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  bool _instant = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: GradientAppBar(
        title: 'Your Cart',
        style: AppBarStyle.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 60,
                        color: AppTheme.primary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Your cart is empty',
                      style: AppTheme.headingStyle().copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Add services from Home or Services to get started',
                      style: AppTheme.bodyStyle().copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<NavProvider>().setIndex(1);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppTheme.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          ),
                        ),
                        child: Text(
                          'Browse services',
                          style: AppTheme.buttonStyle().copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      'When do you need help?',
                      style: AppTheme.subheadingStyle(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ScheduleChip(
                            label: 'Instant',
                            subtitle: '~10 mins',
                            icon: Icons.flash_on_rounded,
                            selected: _instant,
                            onTap: () => setState(() => _instant = true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ScheduleChip(
                            label: 'Schedule',
                            subtitle: 'Pick time',
                            icon: Icons.calendar_today_rounded,
                            selected: !_instant,
                            onTap: () =>
                                setState(() => _instant = false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your services',
                          style: AppTheme.subheadingStyle(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${cart.itemCount} item${cart.itemCount > 1 ? 's' : ''}',
                            style: AppTheme.captionStyle().copyWith(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...cart.items.map(
                      (item) => _CartCard(
                        item: item,
                        onQuantityChanged: (q) => cart
                            .updateQuantity(item.service.id, q),
                        onRemove: () =>
                            cart.removeFromCart(item.service.id),
                      ),
                    ),
                  ],
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
                  child: Column(
                    children: [
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
                            style: AppTheme.headingStyle().copyWith(
                              color: AppTheme.primary,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfirmBookingScreen(
                                    instant: _instant),
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
                            'Proceed to checkout',
                            style: AppTheme.buttonStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  const _ScheduleChip({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
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
                ? AppTheme.primary.withOpacity(0.1)
                : AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 26,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: AppTheme.subheadingStyle().copyWith(
                  fontSize: 14,
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.captionStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartCard extends StatelessWidget {
  const _CartCard({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: AppTheme.cardDecoration().copyWith(
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primary.withOpacity(0.15),
                  AppTheme.primary.withOpacity(0.08),
                ],
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              item.service.emoji,
              style: const TextStyle(fontSize: 26),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.service.name,
                  style: AppTheme.subheadingStyle(),
                ),
                Text(
                  '₹${item.service.basePrice.toInt()} each',
                  style: AppTheme.bodyStyle(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                    Icons.remove_circle_outline, size: 26),
                onPressed: () =>
                    onQuantityChanged(item.quantity - 1),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '${item.quantity}',
                  style: AppTheme.subheadingStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(
                    Icons.add_circle_outline, size: 26),
                onPressed: () =>
                    onQuantityChanged(item.quantity + 1),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.red, size: 24),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
