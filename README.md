# Turf Booking Flutter workspace

This Dart workspace contains three independently built Flutter applications and
the local packages that hold shared foundations.

| Application | Package | MVP platforms |
| --- | --- | --- |
| `customer_app/` | `turf_booking_customer` | Android, iOS |
| `vendor_app/` | `turf_booking_vendor` | Android, iOS, web |
| `admin_app/` | `turf_booking_admin` | Web |

Shared packages live under `packages/`. Applications may depend on those
packages, but shared packages never depend on an application and applications
never import from each other.

## Setup and checks

Run workspace commands from this directory:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed \
  customer_app/lib customer_app/test \
  vendor_app/lib vendor_app/test \
  admin_app/lib admin_app/test packages
flutter analyze
flutter test customer_app/test vendor_app/test admin_app/test
```

Run an application from its package directory. For example:

```bash
cd customer_app
flutter run
```

The customer and vendor identifiers use the project GitHub namespace:

- `io.github.shahirwebo.turfbooking.customer`
- `io.github.shahirwebo.turfbooking.vendor`

Environment suffixes, compile-time API configuration, and environment-specific
display names are configured by `FL-002` and `FL-003`. See
[`../docs/development/flutter-environment-configuration.md`](../docs/development/flutter-environment-configuration.md)
for the API endpoint contract and CI-safe build commands.

## Build environments

Each app has `development`, `staging`, and `production` entry points. The
environment is selected at build time; production uses a separate target and
never falls back to the development target.

For customer and vendor Android/iOS builds, pair the matching entry point with
the native flavor:

```bash
cd customer_app
flutter run --flavor development --target lib/main_development.dart
flutter build appbundle --flavor production --target lib/main_production.dart \
  --dart-define=API_BASE_URL=https://api.example.invalid/api/v1
flutter build ios --flavor staging --target lib/main_staging.dart \
  --dart-define=API_BASE_URL=https://staging-api.example.invalid/api/v1
```

The vendor commands follow the same pattern in `vendor_app/`. Build a web
environment by selecting its matching target, for example:

```bash
cd admin_app
flutter build web --target lib/main_production.dart \
  --dart-define=API_BASE_URL=https://api.example.invalid/api/v1
```

Development defaults to the documented local Laravel URL. Staging and
production must receive `API_BASE_URL` with `--dart-define`; they never fall
back to development. Do not place API URLs, credentials, or service
configuration in source-controlled flavor files.

## Shared API transport

`turf_booking_api_client` provides the explicit shared HTTP transport for all
three applications. It accepts only relative paths beneath the configured API
base URL and leaves authentication, request IDs, retries, and JSON envelope
decoding to their scheduled layers. See
[`../docs/development/flutter-api-client.md`](../docs/development/flutter-api-client.md)
for usage and ownership boundaries.

## Secure session storage

Customer and vendor token storage is isolated by application audience and build
environment through `turf_booking_auth_client`. See
[`../docs/development/flutter-secure-storage.md`](../docs/development/flutter-secure-storage.md)
for platform safeguards and the future authentication ownership boundaries.

## Routing

Each app has an independent `GoRouter` table in `lib/app/routing/`; shared
packages never own product routes. See
[`../docs/development/flutter-routing.md`](../docs/development/flutter-routing.md)
for route ownership, deep-link, and authorization boundaries.
