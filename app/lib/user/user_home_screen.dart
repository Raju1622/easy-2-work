import 'package:flutter/material.dart';

/// User app home – services, cart, bookings.
class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easy 2 Work – User')),
      body: const Center(
        child: Text('User module – services, cart, track booking.'),
      ),
    );
  }
}
