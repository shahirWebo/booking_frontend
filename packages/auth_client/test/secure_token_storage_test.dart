import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_auth_client/turf_booking_auth_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void main() {
  SessionStorageNamespace namespaceFor(
    SessionAudience audience,
    AppEnvironment environment,
  ) {
    return SessionStorageNamespace(
      audience: audience,
      environment: environment,
    );
  }

  test('isolates token keys by application audience and environment', () {
    expect(
      namespaceFor(
        SessionAudience.customer,
        AppEnvironment.development,
      ).accessTokenKey,
      'turf_booking.customer.development.access_token',
    );
    expect(
      namespaceFor(
        SessionAudience.customer,
        AppEnvironment.production,
      ).accessTokenKey,
      'turf_booking.customer.production.access_token',
    );
    expect(
      namespaceFor(
        SessionAudience.vendor,
        AppEnvironment.production,
      ).accessTokenKey,
      'turf_booking.vendor.production.access_token',
    );
  });

  test('writes, reads, and clears only its own access token', () async {
    final store = _InMemorySecureStore();
    final customerStorage = SecureTokenStorage(
      namespace: namespaceFor(
        SessionAudience.customer,
        AppEnvironment.production,
      ),
      store: store,
    );
    final vendorStorage = SecureTokenStorage(
      namespace: namespaceFor(
        SessionAudience.vendor,
        AppEnvironment.production,
      ),
      store: store,
    );

    await customerStorage.writeAccessToken(' customer-token ');
    await vendorStorage.writeAccessToken('vendor-token');
    await customerStorage.clearAccessToken();

    expect(await customerStorage.readAccessToken(), isNull);
    expect(await vendorStorage.readAccessToken(), 'vendor-token');
  });

  test('rejects empty access tokens before writing them', () async {
    final store = _InMemorySecureStore();
    final storage = SecureTokenStorage(
      namespace: namespaceFor(SessionAudience.customer, AppEnvironment.staging),
      store: store,
    );

    expect(() => storage.writeAccessToken('  '), throwsArgumentError);
    expect(store.values, isEmpty);
  });
}

class _InMemorySecureStore implements SecureKeyValueStore {
  final Map<String, String> values = {};

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}
