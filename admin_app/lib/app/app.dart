import 'package:flutter/material.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_admin/app/routing/admin_app_router.dart';

class AdminApp extends StatelessWidget {
  AdminApp({super.key, required ApiConfiguration configuration})
    : configuration = configuration,
      _router = AdminAppRouter(environment: configuration.environment);

  final ApiConfiguration configuration;
  final AdminAppRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: configuration.environment.displayNameFor('Turf Booking Admin'),
      routerConfig: _router.router,
    );
  }
}
