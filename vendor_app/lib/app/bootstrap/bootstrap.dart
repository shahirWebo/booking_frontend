import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/app.dart';
import 'package:turf_booking_vendor/app/state/app_environment.dart';

void runVendorApp(ApiConfiguration configuration) {
  runApp(
    ProviderScope(
      overrides: [
        vendorAppEnvironmentProvider.overrideWithValue(
          configuration.environment,
        ),
      ],
      child: VendorApp(configuration: configuration),
    ),
  );
}
