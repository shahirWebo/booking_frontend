import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_auth_client/turf_booking_auth_client.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_customer/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_customer/app/state/app_environment.dart';

void main() {
  test('injects customer-scoped infrastructure from configuration', () {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.staging,
      baseUrl: 'https://staging-api.example.invalid/api/v1',
    );
    final container = ProviderContainer(
      overrides: [
        customerApiConfigurationProvider.overrideWithValue(configuration),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(customerAppEnvironmentProvider),
      AppEnvironment.staging,
    );
    expect(
      identical(
        container.read(customerApiClientProvider),
        container.read(customerApiClientProvider),
      ),
      isTrue,
    );
    expect(
      container.read(customerTokenStorageProvider).namespace.audience,
      SessionAudience.customer,
    );
  });
}
