import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key, required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: environment.displayNameFor('Turf Booking'),
      home: _CustomerFoundationScreen(environment: environment),
    );
  }
}

class _CustomerFoundationScreen extends StatelessWidget {
  const _CustomerFoundationScreen({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sports_soccer, size: 56),
            const SizedBox(height: 16),
            Text(environment.displayNameFor('Turf Booking')),
            const SizedBox(height: 8),
            const Text('Customer app foundation'),
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
