import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/routing/customer_app_router.dart';

class CustomerApp extends StatelessWidget {
  CustomerApp({super.key, required ApiConfiguration configuration})
    : configuration = configuration,
      _router = CustomerAppRouter(environment: configuration.environment);

  final ApiConfiguration configuration;
  final CustomerAppRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: configuration.environment.displayNameFor('Turf Booking'),
      routerConfig: _router.router,
    );
  }
}
