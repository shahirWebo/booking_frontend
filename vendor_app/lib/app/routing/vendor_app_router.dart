import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_vendor/app/foundation_screen.dart';

abstract final class VendorRoutePaths {
  static const home = '/';
}

/// Vendor-owned route table. Feature routes are added here by their owners.
class VendorAppRouter {
  VendorAppRouter({required AppEnvironment environment})
    : router = GoRouter(
        initialLocation: VendorRoutePaths.home,
        routes: [
          GoRoute(
            path: VendorRoutePaths.home,
            name: 'vendor-home',
            builder: (context, state) =>
                VendorFoundationScreen(environment: environment),
          ),
        ],
        errorBuilder: (context, state) =>
            _UnknownVendorRoute(environment: environment),
      );

  final GoRouter router;
}

class _UnknownVendorRoute extends StatelessWidget {
  const _UnknownVendorRoute({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Vendor route not found in ${environment.label}.'),
      ),
    );
  }
}
