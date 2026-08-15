/// Framework-neutral primitives shared by Turf Booking applications.
library;

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
