import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:turf_booking_admin/app/foundation_screen.dart';
import 'package:turf_booking_core/turf_booking_core.dart';
import 'package:turf_booking_localization/turf_booking_localization.dart';

abstract final class AdminRoutePaths {
  static const home = '/';
}

/// Admin-owned route table. Feature routes are added here by their owners.
class AdminAppRouter {
  AdminAppRouter({required AppEnvironment environment})
    : router = GoRouter(
        initialLocation: AdminRoutePaths.home,
        routes: [
          GoRoute(
            path: AdminRoutePaths.home,
            name: 'admin-home',
            builder: (context, state) =>
                AdminFoundationScreen(environment: environment),
          ),
        ],
        errorBuilder: (context, state) =>
            _UnknownAdminRoute(environment: environment),
      );

  final GoRouter router;
}

class _UnknownAdminRoute extends StatelessWidget {
  const _UnknownAdminRoute({required this.environment});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) {
    final pageNotFound =
        TurfBookingLocalizations.of(context)?.pageNotFound ?? 'Page not found';

    return Scaffold(
      body: Center(child: Text('$pageNotFound (${environment.label}).')),
    );
  }
}
