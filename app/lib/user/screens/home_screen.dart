import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/models/service_model.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/providers/nav_provider.dart';
import '../../shared/widgets/gradient_app_bar.dart';
import 'service_detail_screen.dart';

/// Home – location, search, banner, services grid (6)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String _gridLabel(ServiceModel s) {
    if (s.id == 'bathroom') return 'Cleaning';
    if (s.id == 'cooler') return 'Repairs';
    return s.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: GradientAppBar(
        title: 'Easy 2 Work',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                _greeting,
                style: AppTheme.captionStyle().copyWith(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: 4),
              Text(
                'What do you need today?',
                style: AppTheme.headingStyle()
                    .copyWith(fontSize: 22, height: 1.2),
              )
                  .animate()
                  .fadeIn(delay: 50.ms, duration: 300.ms)
                  .slideX(begin: -0.02, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 20),
              _LocationChip(location: 'Varanasi'),
              const SizedBox(height: 14),
              _SearchBar(
                hint: 'Search services',
                onTap: () => context.read<NavProvider>().setIndex(1),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your home, professionally cleaned — exactly when you need it.',
                        style: AppTheme.bodyStyle().copyWith(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.98),
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(
                        Icons.home_repair_service_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 350.ms)
                  .slideY(begin: 0.03, end: 0, curve: Curves.easeOut),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular services',
                    style: AppTheme.subheadingStyle()
                        .copyWith(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () =>
                        context.read<NavProvider>().setIndex(1),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'See all',
                      style: AppTheme.subheadingStyle().copyWith(
                        fontSize: 14,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(delay: 120.ms),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.92,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: homeGridServices.length,
                itemBuilder: (context, index) {
                  final service = homeGridServices[index];
                  final label = _gridLabel(service);
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ServiceDetailScreen(service: service),
                          ),
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusLg),
                      splashColor:
                          AppTheme.primary.withOpacity(0.08),
                      highlightColor:
                          AppTheme.primary.withOpacity(0.04),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: AppTheme.elevatedCard(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primary
                                        .withOpacity(0.18),
                                    AppTheme.primary
                                        .withOpacity(0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppTheme.radiusMd),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                service.emoji,
                                style: const TextStyle(fontSize: 26),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              label,
                              style: AppTheme.subheadingStyle()
                                  .copyWith(fontSize: 14),
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
                      .fadeIn(
                          delay: (140 + index * 45).ms,
                          duration: 350.ms)
                      .slideY(
                          begin: 0.04, end: 0,
                          curve: Curves.easeOut);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded,
                  size: 20, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                location,
                style:
                    AppTheme.subheadingStyle().copyWith(fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded,
                  size: 22, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.hint, required this.onTap});

  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppTheme.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.search_rounded,
                  size: 22, color: AppTheme.textSecondary),
              const SizedBox(width: 12),
              Text(
                hint,
                style: AppTheme.bodyStyle().copyWith(
                    color: AppTheme.textSecondary, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
