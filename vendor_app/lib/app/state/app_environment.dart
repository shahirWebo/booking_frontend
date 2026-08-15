import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/dependencies/app_dependencies.dart';

/// Build environment derived from the vendor app's injected configuration.
final vendorAppEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => ref.watch(vendorApiConfigurationProvider).environment,
);
