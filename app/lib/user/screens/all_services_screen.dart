import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/models/service_model.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/nav_provider.dart';
import '../../shared/widgets/gradient_app_bar.dart';
import 'service_detail_screen.dart';

/// All Services – professional grid
class AllServicesScreen extends StatelessWidget {
  const AllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: GradientAppBar(
        title: 'Services',
        style: AppBarStyle.gradient,
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) {
              if (cart.itemCount == 0) return const SizedBox.shrink();
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_rounded),
                    onPressed: () =>
                        context.read<NavProvider>().setIndex(2),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All services',
                    style: AppTheme.headingStyle().copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select a service — view pricing and add to cart',
                    style:
                        AppTheme.captionStyle().copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.88,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: allServices.length,
                itemBuilder: (context, index) {
                  final service = allServices[index];
                  return _ServiceTile(
                    service: service,
                    index: index,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ServiceDetailScreen(service: service),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.index,
    required this.onTap,
  });

  final ServiceModel service;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        splashColor: AppTheme.primary.withOpacity(0.08),
        highlightColor: AppTheme.primary.withOpacity(0.04),
        child: Container(
          decoration: AppTheme.elevatedCard(),
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withOpacity(0.18),
                      AppTheme.primary.withOpacity(0.08),
                    ],
                  ),
                  borderRadius:
                      BorderRadius.circular(AppTheme.radiusMd),
                ),
                alignment: Alignment.center,
                child: Text(
                  service.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                service.name,
                style:
                    AppTheme.subheadingStyle().copyWith(fontSize: 14),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                '₹${service.basePrice.toInt()} onwards',
                style: AppTheme.bodyStyle().copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (50 * index).ms, duration: 400.ms)
        .slideY(begin: 0.05, end: 0, curve: Curves.easeOut);
  }
}
