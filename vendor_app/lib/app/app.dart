import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/routing/vendor_app_router.dart';
import 'package:turf_booking_vendor/app/state/app_environment.dart';
import 'package:turf_booking_design_system/turf_booking_design_system.dart';
import 'package:turf_booking_localization/turf_booking_localization.dart';

class VendorApp extends ConsumerWidget {
  VendorApp({super.key, required ApiConfiguration configuration})
    : configuration = configuration,
      _router = VendorAppRouter(environment: configuration.environment);

  final ApiConfiguration configuration;
  final VendorAppRouter _router;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final environment = ref.watch(vendorAppEnvironmentProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: environment.displayNameFor('Turf Booking Vendor'),
      theme: TurfBookingTheme.light,
      darkTheme: TurfBookingTheme.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: TurfBookingLocalizations.localizationsDelegates,
      supportedLocales: TurfBookingLocalizations.supportedLocales,
      routerConfig: _router.router,
    );
  }
}
