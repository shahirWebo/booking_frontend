import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_api_client/turf_booking_api_client.dart';
import 'package:turf_booking_auth_client/turf_booking_auth_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// Build configuration supplied only by the vendor composition root.
final vendorApiConfigurationProvider = Provider<ApiConfiguration>((ref) {
  throw StateError('Vendor API configuration was not configured.');
});

/// App-scoped transport. Feature providers may depend on it, never construct it.
final vendorApiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    configuration: ref.watch(vendorApiConfigurationProvider),
  );
  ref.onDispose(client.close);

  return client;
});

/// Vendor-only session storage, isolated from customer storage by namespace.
final vendorTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  final environment = ref.watch(vendorApiConfigurationProvider).environment;

  return SecureTokenStorage(
    namespace: SessionStorageNamespace(
      audience: SessionAudience.vendor,
      environment: environment,
    ),
  );
});
