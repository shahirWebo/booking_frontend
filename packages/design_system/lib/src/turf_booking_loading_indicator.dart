import 'package:flutter/material.dart';

import 'turf_booking_theme.dart';

/// An accessible, themed loading indicator for short asynchronous waits.
///
/// Supply [semanticLabel] from the calling app's localizations. [message] is
/// optional visual copy, which is announced through [semanticLabel] rather
/// than repeated by a screen reader.
class TurfBookingLoadingIndicator extends StatelessWidget {
  const TurfBookingLoadingIndicator({
    required this.semanticLabel,
    super.key,
    this.message,
    this.size = 32,
  }) : assert(semanticLabel != ''),
       assert(size > 0);

  final String semanticLabel;
  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    final progressIndicator = SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(),
    );

    final content = message == null
        ? progressIndicator
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              progressIndicator,
              SizedBox(height: TurfBookingSpacing.small),
              Text(message!, textAlign: TextAlign.center),
            ],
          );

    return Semantics(
      label: semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(child: content),
    );
  }
}
