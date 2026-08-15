import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

class VendorFoundationScreen extends StatelessWidget {
  const VendorFoundationScreen({super.key, required this.environment});

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
