import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/app.dart';
import 'package:turf_booking_vendor/app/dependencies/app_dependencies.dart';

void runVendorApp(ApiConfiguration configuration) {
  runApp(
    ProviderScope(
      overrides: [
        vendorApiConfigurationProvider.overrideWithValue(configuration),
      ],
      child: VendorApp(configuration: configuration),
    ),
  );
}
