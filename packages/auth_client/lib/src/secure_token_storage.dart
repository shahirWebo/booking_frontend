import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

/// The independent application audiences that share the customer/vendor token
/// storage mechanism.
enum SessionAudience { customer, vendor }

/// Namespaces persisted session values by product and build environment.
class SessionStorageNamespace {
  const SessionStorageNamespace({
    required this.audience,
    required this.environment,
  });

  final SessionAudience audience;
  final AppEnvironment environment;

  String get accessTokenKey =>
      'turf_booking.${audience.name}.${environment.name}.access_token';
}

/// Minimal platform-secure key-value operations needed for session storage.
abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);

  Future<void> write({required String key, required String value});

  Future<void> delete(String key);
}

/// `flutter_secure_storage` adapter backed by platform secure storage.
class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  FlutterSecureKeyValueStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.unlocked_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }
}

/// Stores one application's access token without sharing it across audiences
/// or environments.
class SecureTokenStorage {
  SecureTokenStorage({required this.namespace, SecureKeyValueStore? store})
    : _store = store ?? FlutterSecureKeyValueStore();

  final SessionStorageNamespace namespace;
  final SecureKeyValueStore _store;

  Future<String?> readAccessToken() => _store.read(namespace.accessTokenKey);

  Future<void> writeAccessToken(String accessToken) {
    final normalizedToken = accessToken.trim();
    if (normalizedToken.isEmpty) {
      throw ArgumentError.value(
        accessToken,
        'accessToken',
        'An access token must not be empty.',
      );
    }

    return _store.write(key: namespace.accessTokenKey, value: normalizedToken);
  }

  /// Removes only this application's token; it cannot clear another audience.
  Future<void> clearAccessToken() => _store.delete(namespace.accessTokenKey);
}
