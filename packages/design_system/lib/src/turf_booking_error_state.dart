import 'package:flutter/material.dart';

import 'turf_booking_theme.dart';

/// A consistent accessible presentation for a request or operation failure.
///
/// Supply [title], [description], and [retryLabel] from the calling app's
/// localizations. [onRetry] is optional because some failures cannot be
/// retried safely or meaningfully.
class TurfBookingErrorState extends StatelessWidget {
  const TurfBookingErrorState({
    required this.title,
    required this.description,
    super.key,
    this.onRetry,
    this.retryLabel,
  }) : assert(title != ''),
       assert(description != ''),
       assert(
         (onRetry == null && retryLabel == null) ||
             (onRetry != null && retryLabel != null && retryLabel != ''),
       );

  final String title;
  final String description;
  final VoidCallback? onRetry;
  final String? retryLabel;

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
              child: Icon(
                Icons.error_outline,
                color: colorScheme.error,
                size: 48,
              ),
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
            if (onRetry case final onRetry?) ...[
              const SizedBox(height: TurfBookingSpacing.large),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
