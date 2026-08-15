import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key, required this.configuration});

  final ApiConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: configuration.environment.displayNameFor('Turf Booking Admin'),
      home: _AdminFoundationScreen(environment: configuration.environment),
    );
  }
}

class _AdminFoundationScreen extends StatelessWidget {
  const _AdminFoundationScreen({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.admin_panel_settings, size: 56),
            const SizedBox(height: 16),
            Text(environment.displayNameFor('Turf Booking Admin')),
            const SizedBox(height: 8),
            const Text('Admin portal foundation'),
            if (!environment.isProduction) ...[
              const SizedBox(height: 8),
              Text(environment.label),
            ],
          ],
        ),
      ),
    );
  }
}
