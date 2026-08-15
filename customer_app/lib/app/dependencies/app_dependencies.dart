import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turf_booking_api_client/turf_booking_api_client.dart';
import 'package:turf_booking_auth_client/turf_booking_auth_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// Build configuration supplied only by the customer composition root.
final customerApiConfigurationProvider = Provider<ApiConfiguration>((ref) {
  throw StateError('Customer API configuration was not configured.');
});

/// App-scoped transport. Feature providers may depend on it, never construct it.
final customerApiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(
    configuration: ref.watch(customerApiConfigurationProvider),
  );
  ref.onDispose(client.close);

  return client;
});

/// Customer-only session storage, isolated from vendor storage by namespace.
final customerTokenStorageProvider = Provider<SecureTokenStorage>((ref) {
  final environment = ref.watch(customerApiConfigurationProvider).environment;

  return SecureTokenStorage(
    namespace: SessionStorageNamespace(
      audience: SessionAudience.customer,
      environment: environment,
    ),
  );
});
