import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

// Logger instance used for logging messages related to Game Services Firebase Authentication.
final Logger logger = Logger('GameServiceFirebaseAuth');

// A flag to track whether logging is enabled or disabled.
bool _enabled = false;

// StreamSubscription to listen for log records.
StreamSubscription<LogRecord>? _subscription;

/// Logs a message if logging is enabled, at the specified [level].
///
/// The default log level is [Level.INFO], but it can be adjusted for more or less verbosity.
///
/// Example usage:
/// ```dart
/// log('This is an info message.');
/// log('This is an error message.', level: Level.SEVERE);
/// ```
void log(String message, {Level level = Level.INFO}) {
  if (_enabled) {
    logger.log(level, message);
  }
}

/// Enables or disables logging for Game Services Firebase Authentication.
///
/// If [enabled] is `true`, log messages will be printed based on the defined log level.
/// If severe logs are encountered (i.e., [Level.SEVERE]), they will be routed to Flutter's error handler.
///
/// When logging is disabled, it cancels any active subscriptions to log records.
///
/// [enabled]:
/// - `true`: enables logging.
/// - `false`: disables logging (default behavior).
///
/// Example usage:
/// ```dart
/// setLogging(enabled: true);
/// ```
void setLogging({bool enabled = false}) {
  // Cancel the previous log subscription, if any.
  _subscription?.cancel();
  _enabled = enabled;

  // Return early if logging is disabled or hierarchical logging is already enabled.
  if (!enabled || hierarchicalLoggingEnabled) {
    return;
  }

  // Listen to log records and handle logs accordingly.
  _subscription = logger.onRecord.listen((LogRecord record) {
    if (record.level >= Level.SEVERE) {
      // If the log level is SEVERE or higher, report it to Flutter's error handling system.
      final Object? error = record.error;
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(
          exception: error is Exception ? error : Exception(error),
          stack: record.stackTrace,
          library: record.loggerName,
          context: ErrorDescription(record.message),
        ),
      );
    } else {
      // Log messages with lower severity (INFO, WARNING, etc.) using the `developer.log` function.
      developer.log(
        record.message,
        time: record.time,
        sequenceNumber: record.sequenceNumber,
        level: record.level.value,
        name: record.loggerName,
        zone: record.zone,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    }
  });
}
