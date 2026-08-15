import 'package:test/test.dart';
import 'package:turf_booking_core/turf_booking_core.dart';

void main() {
  test('redacts sensitive context recursively before logging', () {
    final logger = _RecordingLogger();
    final observability = AppObservability(
      logger: logger,
      crashReporter: _RecordingCrashReporter(),
    );

    observability.log(
      AppLogLevel.warning,
      'booking.request_failed',
      context: {
        'request_id': '01ARZ3NDEKTSV4RRFFQ69G5FAV',
        'authorization': 'Bearer private-token',
        'details': {'email': 'customer@example.test', 'attempt': 2},
      },
    );

    expect(logger.events.single.context, {
      'request_id': '01ARZ3NDEKTSV4RRFFQ69G5FAV',
      'authorization': LogContextRedactor.redactedValue,
      'details': {'email': LogContextRedactor.redactedValue, 'attempt': 2},
    });
  });

  test('redacts crash context before sending it to the crash reporter', () {
    final reporter = _RecordingCrashReporter();
    final observability = AppObservability(
      logger: _RecordingLogger(),
      crashReporter: reporter,
    );

    observability.reportCrash(
      event: 'payment.checkout_failed',
      errorType: 'StateError',
      message: 'Checkout could not be started.',
      context: const {'payment_token': 'private-token'},
    );

    expect(reporter.reports.single.context, {
      'payment_token': LogContextRedactor.redactedValue,
    });
  });

  test('does not let provider failures affect application behavior', () {
    final observability = AppObservability(
      logger: _ThrowingLogger(),
      crashReporter: _ThrowingCrashReporter(),
    );

    expect(
      () => observability.log(AppLogLevel.info, 'app.started'),
      returnsNormally,
    );
    expect(
      () => observability.reportCrash(
        event: 'app.unexpected_failure',
        errorType: 'StateError',
      ),
      returnsNormally,
    );
  });

  test('rejects unstable event names before sending data to a provider', () {
    final observability = AppObservability(
      logger: _RecordingLogger(),
      crashReporter: _RecordingCrashReporter(),
    );

    expect(
      () => observability.log(AppLogLevel.info, 'App Started'),
      throwsArgumentError,
    );
  });
}

class _RecordingLogger implements AppLogger {
  final events = <AppLogEvent>[];

  @override
  void log(AppLogEvent event) => events.add(event);
}

class _RecordingCrashReporter implements CrashReporter {
  final reports = <AppCrashReport>[];

  @override
  void report(AppCrashReport report) => reports.add(report);
}

class _ThrowingLogger implements AppLogger {
  @override
  void log(AppLogEvent event) => throw StateError('Unavailable');
}

class _ThrowingCrashReporter implements CrashReporter {
  @override
  void report(AppCrashReport report) => throw StateError('Unavailable');
}
