import 'package:test/test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void main() {
  group('ApiConfiguration', () {
    test('uses the local versioned endpoint for development by default', () {
      final configuration = ApiConfiguration.fromCompileTime(
        AppEnvironment.development,
      );

      expect(
        configuration.baseUrl,
        ApiConfiguration.localDevelopmentBaseUrl,
      );
    });

    test('requires an endpoint outside development', () {
      expect(
        () => ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.staging,
          baseUrl: '',
        ),
        throwsArgumentError,
      );
      expect(
        () => ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.production,
          baseUrl: '',
        ),
        throwsArgumentError,
      );
    });

    test('accepts a normalized HTTPS versioned endpoint', () {
      final configuration = ApiConfiguration.fromBaseUrl(
        environment: AppEnvironment.staging,
        baseUrl: 'https://staging-api.example.invalid/api/v1/',
      );

      expect(
        configuration.baseUrl.toString(),
        'https://staging-api.example.invalid/api/v1',
      );
    });

    test('rejects unsafe production endpoint values', () {
      expect(
        () => ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.production,
          baseUrl: 'http://api.example.invalid/api/v1',
        ),
        throwsArgumentError,
      );
      expect(
        () => ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.production,
          baseUrl: 'https://localhost/api/v1',
        ),
        throwsArgumentError,
      );
    });

    test('rejects non-versioned endpoint values', () {
      expect(
        () => ApiConfiguration.fromBaseUrl(
          environment: AppEnvironment.development,
          baseUrl: 'http://localhost:8000/api',
        ),
        throwsArgumentError,
      );
    });
  });
}
