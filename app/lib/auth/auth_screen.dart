import 'package:flutter/material.dart';

/// Placeholder auth screen – login / register.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Register')),
      body: const Center(
        child: Text('Auth module – login & registration will go here.'),
      ),
    );
  }
}
