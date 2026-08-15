/// Framework-neutral primitives shared by Turf Booking applications.
library;

export 'src/observability.dart';

/// The build-time environment selected by an application entry point.
enum AppEnvironment {
  development('Development', 'Dev'),
  staging('Staging', 'Staging'),
  production('Production', '');

  const AppEnvironment(this.label, this.displayNameSuffix);

  /// Human-readable name for developer tooling and non-production UI.
  final String label;

  /// Suffix appended to an app display name outside production.
  final String displayNameSuffix;

  bool get isProduction => this == AppEnvironment.production;

  /// Returns the unambiguous display name for this environment.
  String displayNameFor(String baseName) {
    if (isProduction) {
      return baseName;
    }

    return '$baseName $displayNameSuffix';
  }
}

/// Build-time API configuration shared by all Flutter applications.
///
/// Staging and production intentionally have no source-controlled fallback.
/// Supply their endpoint with `--dart-define=API_BASE_URL=...`.
class ApiConfiguration {
  const ApiConfiguration._({required this.environment, required this.baseUrl});

  /// Laravel's API versioned local-development endpoint.
  static final Uri localDevelopmentBaseUrl = Uri.parse(
    'http://localhost:8000/api/v1',
  );

  final AppEnvironment environment;
  final Uri baseUrl;

  /// Reads the URL compiled into the application with `--dart-define`.
  factory ApiConfiguration.fromCompileTime(AppEnvironment environment) {
    const configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

    return ApiConfiguration.fromBaseUrl(
      environment: environment,
      baseUrl:
          configuredBaseUrl.isEmpty && environment == AppEnvironment.development
          ? localDevelopmentBaseUrl.toString()
          : configuredBaseUrl,
    );
  }

  /// Validates a supplied URL, primarily for bootstrap and focused tests.
  factory ApiConfiguration.fromBaseUrl({
    required AppEnvironment environment,
    required String baseUrl,
  }) {
    final value = baseUrl.trim();
    if (value.isEmpty) {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        '${environment.label} requires API_BASE_URL.',
      );
    }

    final parsed = Uri.tryParse(value);
    if (parsed == null ||
        !parsed.hasScheme ||
        parsed.host.isEmpty ||
        (parsed.scheme != 'http' && parsed.scheme != 'https') ||
        parsed.hasQuery ||
        parsed.hasFragment ||
        parsed.userInfo.isNotEmpty) {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        'API_BASE_URL must be an absolute HTTP(S) URL without credentials, '
            'query parameters, or fragments.',
      );
    }

    final normalizedPath = parsed.path.replaceFirst(RegExp(r'/+$'), '');
    if (normalizedPath != '/api/v1') {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        'API_BASE_URL must target the versioned /api/v1 endpoint.',
      );
    }

    if (environment != AppEnvironment.development && parsed.scheme != 'https') {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        '${environment.label} API_BASE_URL must use HTTPS.',
      );
    }

    if (environment.isProduction && _isLocalHost(parsed.host)) {
      throw ArgumentError.value(
        baseUrl,
        'baseUrl',
        'Production API_BASE_URL must not point to a local host.',
      );
    }

    return ApiConfiguration._(
      environment: environment,
      baseUrl: parsed.replace(path: normalizedPath),
    );
  }

  static bool _isLocalHost(String host) {
    final normalizedHost = host.toLowerCase();

    return normalizedHost == 'localhost' ||
        normalizedHost == '::1' ||
        normalizedHost == '0.0.0.0' ||
        normalizedHost.startsWith('127.') ||
        normalizedHost.endsWith('.local');
  }
}
