/// Severity for an application log event.
enum AppLogLevel { debug, info, warning, error }

/// A vendor-neutral sink for safe structured application events.
abstract interface class AppLogger {
  void log(AppLogEvent event);
}

/// A vendor-neutral sink for safe crash and non-fatal error reports.
abstract interface class CrashReporter {
  void report(AppCrashReport report);
}

/// A structured event with context already redacted by [AppObservability].
class AppLogEvent {
  const AppLogEvent._({
    required this.level,
    required this.name,
    required this.context,
  });

  final AppLogLevel level;
  final String name;
  final Map<String, Object?> context;
}

/// A safe report for an unexpected application failure.
///
/// [errorType] and [message] must be safe summaries. Do not pass a raw
/// exception message, request body, token, or other untrusted payload here.
class AppCrashReport {
  const AppCrashReport._({
    required this.event,
    required this.errorType,
    required this.context,
    this.message,
    this.stackTrace,
  });

  final String event;
  final String errorType;
  final String? message;
  final StackTrace? stackTrace;
  final Map<String, Object?> context;
}

/// Creates safe, structured observability data before it reaches a provider.
///
/// Provider failures are ignored so telemetry never changes product behavior.
class AppObservability {
  factory AppObservability({
    required AppLogger logger,
    required CrashReporter crashReporter,
  }) => AppObservability._(logger, crashReporter);

  AppObservability._(this._logger, this._crashReporter);

  final AppLogger _logger;
  final CrashReporter _crashReporter;

  void log(
    AppLogLevel level,
    String name, {
    Map<String, Object?> context = const {},
  }) {
    _validateEventName(name);
    final event = AppLogEvent._(
      level: level,
      name: name,
      context: LogContextRedactor.redact(context),
    );

    try {
      _logger.log(event);
    } catch (_) {
      // Observability providers must never affect app behavior.
    }
  }

  void reportCrash({
    required String event,
    required String errorType,
    String? message,
    StackTrace? stackTrace,
    Map<String, Object?> context = const {},
  }) {
    _validateEventName(event);
    final report = AppCrashReport._(
      event: event,
      errorType: errorType,
      message: message,
      stackTrace: stackTrace,
      context: LogContextRedactor.redact(context),
    );

    try {
      _crashReporter.report(report);
    } catch (_) {
      // Observability providers must never affect app behavior.
    }
  }

  static void _validateEventName(String value) {
    if (!RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)+$').hasMatch(value)) {
      throw ArgumentError.value(
        value,
        'event name',
        'Event names must be lowercase dot-separated identifiers.',
      );
    }
  }
}

/// Recursively removes sensitive values from structured observability context.
abstract final class LogContextRedactor {
  static const redactedValue = '[REDACTED]';

  static final _sensitiveKey = RegExp(
    r'authorization|cookie|password|secret|token|otp|signature|api[_-]?key|'
    r'private[_-]?key|credential|card|pan|cvv|phone|email|body|payload',
    caseSensitive: false,
  );

  static Map<String, Object?> redact(Map<String, Object?> context) {
    return Map.unmodifiable(
      context.map((key, value) => MapEntry(key, _redactValue(key, value))),
    );
  }

  static Object? _redactValue(String key, Object? value) {
    if (_sensitiveKey.hasMatch(key)) {
      return redactedValue;
    }
    if (value is Map<String, Object?>) {
      return redact(value);
    }
    if (value is List<Object?>) {
      return List.unmodifiable(
        value.map((entry) => _redactListEntry(entry)).toList(growable: false),
      );
    }

    return value;
  }

  static Object? _redactListEntry(Object? value) {
    if (value is Map<String, Object?>) {
      return redact(value);
    }
    if (value is List<Object?>) {
      return List.unmodifiable(
        value.map(_redactListEntry).toList(growable: false),
      );
    }

    return value;
  }
}
