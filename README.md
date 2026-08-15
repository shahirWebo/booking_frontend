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
display names are introduced by `FL-002` and `FL-003`.
