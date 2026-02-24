import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/user_address_provider.dart';
import 'login_screen.dart';
import 'my_bookings_screen.dart';
import 'static/why_us_screen.dart';
import 'static/services_info_screen.dart';
import 'static/how_it_works_screen.dart';
import 'static/faq_screen.dart';
import 'static/terms_screen.dart';
import 'static/privacy_screen.dart';

/// Profile – Name, Phone, Address (add/edit), My Bookings, Logout + footer links
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String _name = 'User Name';
  static const String _phone = '+91 98765 43210';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTheme.subheadingStyle().copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: AppTheme.cardDecoration().copyWith(
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        AppTheme.primary.withOpacity(0.15),
                    child: Text(
                      _name.substring(0, 1).toUpperCase(),
                      style: AppTheme.headingStyle().copyWith(
                        fontSize: 32,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_name,
                      style: AppTheme.headingStyle()
                          .copyWith(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(_phone, style: AppTheme.bodyStyle()),
                  const SizedBox(height: 8),
                  Consumer<UserAddressProvider>(
                    builder: (context, addr, _) => Text(
                      addr.hasAddress
                          ? addr.address
                          : 'Add address for service booking',
                      style: AppTheme.captionStyle().copyWith(
                        color: addr.hasAddress
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontStyle: addr.hasAddress
                            ? FontStyle.normal
                            : FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _Tile(
              icon: Icons.add_location_alt_outlined,
              title: 'Add / Edit address',
              onTap: () => _showAddEditAddressDialog(context),
            ),
            _Tile(
              icon: Icons.calendar_today_rounded,
              title: 'My Bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MyBookingsScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Information',
              style: AppTheme.captionStyle().copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _Tile(
                icon: Icons.thumb_up_rounded,
                title: 'Why Us',
                onTap: () =>
                    _push(context, const WhyUsScreen())),
            _Tile(
                icon: Icons.grid_view_rounded,
                title: 'Services',
                onTap: () =>
                    _push(context, const ServicesInfoScreen())),
            _Tile(
                icon: Icons.help_outline_rounded,
                title: 'How It Works',
                onTap: () =>
                    _push(context, const HowItWorksScreen())),
            _Tile(
                icon: Icons.quiz_outlined,
                title: 'FAQs',
                onTap: () => _push(context, const FaqScreen())),
            _Tile(
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () =>
                    _push(context, const TermsScreen())),
            _Tile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () =>
                    _push(context, const PrivacyScreen())),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void _showAddEditAddressDialog(BuildContext context) {
    final addrProvider = context.read<UserAddressProvider>();
    final controller = TextEditingController(text: addrProvider.address);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add / Edit address'),
        content: SingleChildScrollView(
          child: TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'House no., area, city, state, PIN',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              addrProvider.setAddress(controller.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address saved. It will be used for bookings.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
            'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: TextStyle(
                    color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => const LoginScreen()),
                (r) => false,
              );
            },
            child: const Text('Logout',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(
      {required this.icon,
      required this.title,
      required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.bgCard,
              borderRadius:
                  BorderRadius.circular(14),
              border:
                  Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 24,
                    color: AppTheme.primary),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(title,
                        style: AppTheme.subheadingStyle()
                            .copyWith(fontSize: 15))),
                Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
