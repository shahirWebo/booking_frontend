import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

class VendorApp extends StatelessWidget {
  const VendorApp({super.key, required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: environment.displayNameFor('Turf Booking Vendor'),
      home: _VendorFoundationScreen(environment: environment),
    );
  }
}

class _VendorFoundationScreen extends StatelessWidget {
  const _VendorFoundationScreen({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront, size: 56),
            const SizedBox(height: 16),
            Text(environment.displayNameFor('Turf Booking Vendor')),
            const SizedBox(height: 8),
            const Text('Vendor and staff app foundation'),
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
