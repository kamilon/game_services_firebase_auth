import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

final Logger logger = Logger('GameServiceFirebaseAuth');

bool _enabled = false;

void log(String message, {Level level = Level.INFO}) {
  if (_enabled) {
    logger.log(level, message);
  }
}

StreamSubscription<LogRecord>? _subscription;

void setLogging({bool enabled = false}) {
  _subscription?.cancel();
  _enabled = enabled;
  if (!enabled || hierarchicalLoggingEnabled) {
    return;
  }

  _subscription = logger.onRecord.listen((LogRecord e) {
    if (e.level >= Level.SEVERE) {
      final Object? error = e.error;
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(
          exception: error is Exception ? error : Exception(error),
          stack: e.stackTrace,
          library: e.loggerName,
          context: ErrorDescription(e.message),
        ),
      );
    } else {
      developer.log(
        e.message,
        time: e.time,
        sequenceNumber: e.sequenceNumber,
        level: e.level.value,
        name: e.loggerName,
        zone: e.zone,
        error: e.error,
        stackTrace: e.stackTrace,
      );
    }
  });
}
