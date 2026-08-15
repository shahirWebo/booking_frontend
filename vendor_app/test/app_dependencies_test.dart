import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_auth_client/turf_booking_auth_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_vendor/app/state/app_environment.dart';

void main() {
  test('injects vendor-scoped infrastructure from configuration', () {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.production,
      baseUrl: 'https://api.example.invalid/api/v1',
    );
    final container = ProviderContainer(
      overrides: [
        vendorApiConfigurationProvider.overrideWithValue(configuration),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(vendorAppEnvironmentProvider),
      AppEnvironment.production,
    );
    expect(
      identical(
        container.read(vendorApiClientProvider),
        container.read(vendorApiClientProvider),
      ),
      isTrue,
    );
    expect(
      container.read(vendorTokenStorageProvider).namespace.audience,
      SessionAudience.vendor,
    );
  });
}
