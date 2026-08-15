import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// Build configuration injected by the vendor application's composition root.
final vendorAppEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw StateError('Vendor app environment was not configured.');
});
