import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:turf_booking_admin/app/dependencies/app_dependencies.dart';
import 'package:turf_booking_admin/app/state/app_environment.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void main() {
  test('injects admin-scoped infrastructure from configuration', () {
    final configuration = ApiConfiguration.fromBaseUrl(
      environment: AppEnvironment.production,
      baseUrl: 'https://api.example.invalid/api/v1',
    );
    final container = ProviderContainer(
      overrides: [
        adminApiConfigurationProvider.overrideWithValue(configuration),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(adminAppEnvironmentProvider),
      AppEnvironment.production,
    );
    expect(
      identical(
        container.read(adminApiClientProvider),
        container.read(adminApiClientProvider),
      ),
      isTrue,
    );
  });
}
