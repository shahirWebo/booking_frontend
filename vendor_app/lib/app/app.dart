import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/routing/vendor_app_router.dart';

class VendorApp extends StatelessWidget {
  VendorApp({super.key, required ApiConfiguration configuration})
    : configuration = configuration,
      _router = VendorAppRouter(environment: configuration.environment);

  final ApiConfiguration configuration;
  final VendorAppRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: configuration.environment.displayNameFor('Turf Booking Vendor'),
      routerConfig: _router.router,
    );
  }
}
