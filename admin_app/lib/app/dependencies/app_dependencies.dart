import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_api_client/turf_booking_api_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// Build configuration supplied only by the admin composition root.
final adminApiConfigurationProvider = Provider<ApiConfiguration>((ref) {
  throw StateError('Admin API configuration was not configured.');
});

/// App-scoped transport. Feature providers may depend on it, never construct it.
final adminApiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    configuration: ref.watch(adminApiConfigurationProvider),
  );
  ref.onDispose(client.close);

  return client;
});
