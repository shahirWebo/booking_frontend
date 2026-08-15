import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// Build configuration injected by the customer application's composition root.
final customerAppEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw StateError('Customer app environment was not configured.');
});
