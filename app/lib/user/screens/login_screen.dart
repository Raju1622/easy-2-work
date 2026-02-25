import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/nav_provider.dart';
import 'main_shell.dart';
import '../../worker/worker_shell.dart';

/// Login – choose User or Worker, enter phone, then go to respective flow
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthRole? _selectedRole;
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select User or Worker'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid 10-digit phone number'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await context.read<AuthProvider>().login(_selectedRole!, phone);
    if (!mounted) return;
    // User → Home (tab 0), Worker → Jobs (tab 0)
    context.read<NavProvider>().setIndex(0);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => _selectedRole == AuthRole.user
            ? const MainShell()
            : const WorkerShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Welcome to Easy 2 Work',
                  style: AppTheme.headingStyle().copyWith(fontSize: 26),
                )
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: -0.05, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 8),
                Text(
                  'Choose how you want to continue',
                  style: AppTheme.bodyStyle(),
                )
                    .animate()
                    .fadeIn(delay: 100.ms),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.person_rounded,
                        label: 'User',
                        subtitle: 'Book services',
                        selected: _selectedRole == AuthRole.user,
                        onTap: () =>
                            setState(() => _selectedRole = AuthRole.user),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _RoleCard(
                        icon: Icons.engineering_rounded,
                        label: 'Worker',
                        subtitle: 'Accept jobs',
                        selected: _selectedRole == AuthRole.worker,
                        onTap: () =>
                            setState(() => _selectedRole = AuthRole.worker),
                      ),
                    ),
                  ],
                )
                    .animate()
                    .fadeIn(delay: 150.ms)
                    .slideY(begin: 0.05, end: 0, curve: Curves.easeOut),
                const SizedBox(height: 28),
                Text(
                  'Phone number',
                  style: AppTheme.subheadingStyle().copyWith(fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    hintText: '10-digit mobile number',
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
                    prefixIcon: const Icon(Icons.phone_android_rounded,
                        color: AppTheme.textSecondary),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms),
                const SizedBox(height: 32),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: AppTheme.buttonStyle(),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 250.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withOpacity(0.08)
                : AppTheme.bgCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 36,
                color: selected ? AppTheme.primary : AppTheme.textSecondary,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: AppTheme.subheadingStyle().copyWith(
                  fontSize: 15,
                  color: selected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTheme.captionStyle(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
