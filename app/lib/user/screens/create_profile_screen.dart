import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/nav_provider.dart';
import '../../core/providers/user_address_provider.dart';
import 'main_shell.dart';

/// User login ke baad: pehle location allow, phir profile (name + address) create karein. Profile create hone ke baad hi MainShell.
class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pinController = TextEditingController();
  bool _locationLoading = false;
  bool _locationRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestLocationPermission());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    if (_locationRequested) return;
    _locationRequested = true;
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    if (!mounted) return;
    if (status == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Service ke liye location allow karein – Settings se permission on kar sakte hain.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locationLoading = true);
    var status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    if (status != LocationPermission.whileInUse && status != LocationPermission.always) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location allow karein taaki engineer map se pahunch sake.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() => _locationLoading = false);
      return;
    }
    if (status == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings se location permission on karein.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      setState(() => _locationLoading = false);
      return;
    }
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      await context.read<UserAddressProvider>().setLocation(pos.latitude, pos.longitude);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location saved. Ab address line aur PIN bhar dein.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location nahi mila: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    if (mounted) setState(() => _locationLoading = false);
  }

  Future<void> _createProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your address – engineer yahi aayega'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final pin = _pinController.text.trim();
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter 6-digit PIN code'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await context.read<AuthProvider>().setProfileCreated(name);
    await context.read<UserAddressProvider>().setAddressAndPin(address, pin);
    if (!mounted) return;
    context.read<NavProvider>().setIndex(0);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final phone = auth.phone;
    final phoneDisplay = phone.length >= 10 ? '+91 ${phone.substring(0, 5)} ${phone.substring(5)}' : phone;

    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      appBar: AppBar(
        title: Text(
          'Create Profile',
          style: AppTheme.subheadingStyle().copyWith(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.bgCard,
        elevation: 0,
        scrolledUnderElevation: 1,
        foregroundColor: AppTheme.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, color: AppTheme.primary, size: 28),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Service ke liye location allow karein – engineer map se aapke address tak pahunch payega.',
                      style: AppTheme.bodyStyle().copyWith(
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your name',
              style: AppTheme.subheadingStyle().copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'Full name',
                hintStyle: AppTheme.bodyStyle(),
                filled: true,
                fillColor: AppTheme.bgCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                prefixIcon: const Icon(Icons.person_rounded, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Phone number',
              style: AppTheme.subheadingStyle().copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.bgCard.withOpacity(0.7),
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(color: AppTheme.border),
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.phone_android_rounded, color: AppTheme.textSecondary, size: 22),
                  const SizedBox(width: 12),
                  Text(
                    phoneDisplay.isEmpty ? 'Phone' : phoneDisplay,
                    style: AppTheme.bodyStyle().copyWith(
                      color: phoneDisplay.isEmpty ? AppTheme.textSecondary : AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Service address',
              style: AppTheme.subheadingStyle().copyWith(fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'House no., area, city, state',
                hintStyle: AppTheme.bodyStyle(),
                filled: true,
                fillColor: AppTheme.bgCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _locationLoading ? null : _useCurrentLocation,
              icon: _locationLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
                    )
                  : const Icon(Icons.my_location_rounded, size: 20),
              label: Text(
                _locationLoading ? 'Location le rahe hain...' : 'Use my current location',
                style: AppTheme.bodyStyle().copyWith(fontSize: 14),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: 'PIN code (6 digits)',
                hintStyle: AppTheme.bodyStyle(),
                filled: true,
                fillColor: AppTheme.bgCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  borderSide: const BorderSide(color: AppTheme.border),
                ),
                counterText: '',
                prefixIcon: const Icon(Icons.pin_drop_rounded, color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _createProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                ),
                child: Text('Create Profile', style: AppTheme.buttonStyle()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
