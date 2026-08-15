import 'dart:convert';

import 'api_client.dart';

/// Broad HTTP failure categories for presentation and session adapters.
enum ApiErrorKind {
  badRequest,
  unauthenticated,
  forbidden,
  notFound,
  conflict,
  validation,
  rateLimited,
  server,
  unexpected,
}

/// A safely decoded non-success response from the versioned API.
///
/// Features branch on the stable [code] or [kind], never on [message]. Field
/// messages are presentation text and may change without an API version bump.
class ApiResponseException implements Exception {
  const ApiResponseException({
    required this.statusCode,
    required this.kind,
    required this.code,
    required this.message,
    required this.fieldErrors,
    this.requestID,
  });

  static const _fallbackCode = 'UNEXPECTED_RESPONSE';
  static const _fallbackMessage = 'The request could not be completed.';

  final int statusCode;
  final ApiErrorKind kind;
  final String code;
  final String message;
  final Map<String, List<String>> fieldErrors;
  final String? requestID;

  factory ApiResponseException.fromResponse(ApiResponse response) {
    final envelope = _decodeEnvelope(response.bodyBytes);
    final meta = envelope['meta'] as Map<String, Object?>?;
    final envelopeRequestID = meta?['request_id'];

    return ApiResponseException(
      statusCode: response.statusCode,
      kind: _kindForStatus(response.statusCode),
      code: _safeCode(envelope['code']),
      message: _safeMessage(envelope['message']),
      fieldErrors: _fieldErrors(envelope['errors']),
      requestID:
          response.requestID ??
          (envelopeRequestID is String && envelopeRequestID.isNotEmpty
              ? envelopeRequestID
              : null),
    );
  }

  @override
  String toString() => 'ApiResponseException($statusCode, $code)';

  static Map<String, Object?> _decodeEnvelope(List<int> bodyBytes) {
    try {
      final decoded = jsonDecode(utf8.decode(bodyBytes));
      if (decoded is Map<String, Object?> && decoded['success'] == false) {
        return decoded;
      }
    } on FormatException {
      // A malformed or non-standard failure body intentionally uses fallbacks.
    }

    return const {};
  }

  static String _safeCode(Object? value) {
    if (value is String && RegExp(r'^[A-Z][A-Z0-9_]*$').hasMatch(value)) {
      return value;
    }

    return _fallbackCode;
  }

  static String _safeMessage(Object? value) {
    if (value is String && value.isNotEmpty) {
      return value;
    }

    return _fallbackMessage;
  }

  static Map<String, List<String>> _fieldErrors(Object? value) {
    if (value is! Map<String, Object?>) {
      return const {};
    }

    final entries = <String, List<String>>{};
    for (final entry in value.entries) {
      final rawMessages = entry.value;
      if (rawMessages is! List<Object?>) {
        continue;
      }

      final messages = rawMessages
          .whereType<String>()
          .where((message) => message.isNotEmpty)
          .toList(growable: false);
      if (messages.isNotEmpty) {
        entries[entry.key] = List.unmodifiable(messages);
      }
    }

    return Map.unmodifiable(entries);
  }

  static ApiErrorKind _kindForStatus(int statusCode) => switch (statusCode) {
    400 => ApiErrorKind.badRequest,
    401 => ApiErrorKind.unauthenticated,
    403 => ApiErrorKind.forbidden,
    404 => ApiErrorKind.notFound,
    409 => ApiErrorKind.conflict,
    422 => ApiErrorKind.validation,
    429 => ApiErrorKind.rateLimited,
    >= 500 => ApiErrorKind.server,
    _ => ApiErrorKind.unexpected,
  };
}
