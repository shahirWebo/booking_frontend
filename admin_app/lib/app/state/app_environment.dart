import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_admin/app/dependencies/app_dependencies.dart';

/// Build environment derived from the admin app's injected configuration.
final adminAppEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => ref.watch(adminApiConfigurationProvider).environment,
);
