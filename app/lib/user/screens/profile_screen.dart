import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
        backgroundColor: AppTheme.bgCard,
        elevation: 0,
        scrolledUnderElevation: 1,
        foregroundColor: AppTheme.textPrimary,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 22),
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
              padding: const EdgeInsets.all(28),
              decoration: AppTheme.cardDecoration(),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppTheme.primary.withOpacity(0.12),
                    child: Text(
                      _name.substring(0, 1).toUpperCase(),
                      style: AppTheme.headingStyle().copyWith(
                        fontSize: 34,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _name,
                    style: AppTheme.headingStyle().copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(_phone, style: AppTheme.bodyStyle().copyWith(fontSize: 14)),
                  const SizedBox(height: 12),
                  Consumer<UserAddressProvider>(
                    builder: (context, addr, _) => Text(
                      addr.hasAddress
                          ? addr.fullAddress
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
    final scaffoldContext = context;
    Future<void> useCurrentLocation() async {
      var status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        status = await Geolocator.requestPermission();
        if (status != LocationPermission.whileInUse &&
            status != LocationPermission.always) {
          if (scaffoldContext.mounted) {
            ScaffoldMessenger.of(scaffoldContext).showSnackBar(
              const SnackBar(
                content: Text(
                  'Location allow karein taaki engineer map se pahunch sake.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          return;
        }
      }
      if (status == LocationPermission.deniedForever) {
        if (scaffoldContext.mounted) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text('Settings se location permission on karein.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      }
      try {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        await addrProvider.setLocation(pos.latitude, pos.longitude);
        if (scaffoldContext.mounted) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            const SnackBar(
              content: Text(
                'Location saved. Engineer aapke address par map se pahunch payega.',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (scaffoldContext.mounted) {
          ScaffoldMessenger.of(scaffoldContext).showSnackBar(
            SnackBar(
              content: Text('Location nahi mila: $e'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
    showDialog(
      context: context,
      builder: (ctx) => _AddressDialogContent(
        initialAddress: addrProvider.address,
        initialPinCode: addrProvider.pinCode,
        onSave: (addressLine, pinCode) {
          Navigator.pop(ctx);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            addrProvider.setAddressAndPin(addressLine, pinCode);
            if (scaffoldContext.mounted) {
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                const SnackBar(
                  content: Text('Address & PIN saved. Worker will use it for maps.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          });
        },
        onUseCurrentLocation: useCurrentLocation,
      ),
    );
  }

}

class _AddressDialogContent extends StatefulWidget {
  const _AddressDialogContent({
    required this.initialAddress,
    required this.initialPinCode,
    required this.onSave,
    this.onUseCurrentLocation,
  });

  final String initialAddress;
  final String initialPinCode;
  final void Function(String addressLine, String pinCode) onSave;
  final Future<void> Function()? onUseCurrentLocation;

  @override
  State<_AddressDialogContent> createState() => _AddressDialogContentState();
}

class _AddressDialogContentState extends State<_AddressDialogContent> {
  late final TextEditingController _addressController;
  late final TextEditingController _pinController;
  bool _locationLoading = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(text: widget.initialAddress);
    _pinController = TextEditingController(text: widget.initialPinCode);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add / Edit address'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _addressController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'House no., area, city, state',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'PIN code',
                hintText: 'e.g. 221001',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            if (widget.onUseCurrentLocation != null) ...[
              const SizedBox(height: 12),
              Text(
                'Engineer map se pahunch sake – location allow karein',
                style: AppTheme.captionStyle().copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _locationLoading
                    ? null
                    : () async {
                        setState(() => _locationLoading = true);
                        await widget.onUseCurrentLocation!();
                        if (mounted) setState(() => _locationLoading = false);
                      },
                icon: _locationLoading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.primary,
                        ),
                      )
                    : const Icon(Icons.my_location_rounded, size: 20),
                label: Text(
                  _locationLoading ? 'Location le rahe hain...' : 'Use my current location',
                  style: AppTheme.bodyStyle().copyWith(fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: BorderSide(color: AppTheme.primary),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
        ),
        TextButton(
          onPressed: () => widget.onSave(
            _addressController.text,
            _pinController.text,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

extension on ProfileScreen {
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          splashColor: AppTheme.primary.withOpacity(0.06),
          highlightColor: AppTheme.primary.withOpacity(0.04),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: AppTheme.sectionCard(),
            child: Row(
              children: [
                Icon(icon, size: 24, color: AppTheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTheme.subheadingStyle().copyWith(fontSize: 15),
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 22, color: AppTheme.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
