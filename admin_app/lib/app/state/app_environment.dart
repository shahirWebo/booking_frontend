import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// Build configuration injected by the admin application's composition root.
final adminAppEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw StateError('Admin app environment was not configured.');
});
