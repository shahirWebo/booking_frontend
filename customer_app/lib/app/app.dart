import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/routing/customer_app_router.dart';
import 'package:turf_booking_customer/app/state/app_environment.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';

class CustomerApp extends ConsumerWidget {
  CustomerApp({super.key, required ApiConfiguration configuration})
    : configuration = configuration,
      _router = CustomerAppRouter(environment: configuration.environment);

  final ApiConfiguration configuration;
  final CustomerAppRouter _router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(customerAppEnvironmentProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: environment.displayNameFor('Turf Booking'),
      theme: TurfBookingTheme.light,
      darkTheme: TurfBookingTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router.router,
    );
  }
}
