import 'package:flutter/material.dart';

/// Worker app home – jobs, accept, navigate.
class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Easy 2 Work – Worker')),
      body: const Center(
        child: Text('Worker module – available jobs, accept, navigation.'),
      ),
    );
  }
}
