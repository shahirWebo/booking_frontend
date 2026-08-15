import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/dependencies/app_dependencies.dart';

/// Build environment derived from the customer app's injected configuration.
final customerAppEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => ref.watch(customerApiConfigurationProvider).environment,
);
