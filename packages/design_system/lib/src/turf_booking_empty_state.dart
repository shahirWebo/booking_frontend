import 'package:flutter/material.dart';

import 'turf_booking_theme.dart';

/// A consistent accessible presentation for a successfully empty result.
///
/// Supply [title] and [description] from the calling app's localizations.
/// [action] is optional and should help the user create or discover content;
/// it must not be used to retry a failed request.
class TurfBookingEmptyState extends StatelessWidget {
  const TurfBookingEmptyState({
    required this.title,
    required this.description,
    super.key,
    this.icon = Icons.inbox_outlined,
    this.action,
  }) : assert(title != ''),
       assert(description != '');

  final String title;
  final String description;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TurfBookingSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 48),
            ),
            const SizedBox(height: TurfBookingSpacing.medium),
            Semantics(
              header: true,
              child: Text(
                title,
                style: textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: TurfBookingSpacing.small),
            Text(
              description,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action case final action?) ...[
              const SizedBox(height: TurfBookingSpacing.large),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
