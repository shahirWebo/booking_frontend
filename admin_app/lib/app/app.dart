import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_admin/app/routing/admin_app_router.dart';
import 'package:turf_booking_admin/app/state/app_environment.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';

class AdminApp extends ConsumerWidget {
  AdminApp({super.key, required ApiConfiguration configuration})
    : configuration = configuration,
      _router = AdminAppRouter(environment: configuration.environment);

  final ApiConfiguration configuration;
  final AdminAppRouter _router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(adminAppEnvironmentProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: environment.displayNameFor('Turf Booking Admin'),
      theme: TurfBookingTheme.light,
      darkTheme: TurfBookingTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: _router.router,
    );
  }
}
