import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uskudar_mobile/core/services/firebase_service.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/di/di.dart';

final class LogHelper {
  const LogHelper._();

  static void log(
    LogLevel level,
    String message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = level.name.toUpperCase();
    if (kDebugMode) {
      debugPrint('$prefix: $message');
      if (error != null) debugPrint('$prefix ERROR: $error');
      if (stackTrace != null) debugPrint('$prefix STACKTRACE: $stackTrace');
    }
    _logToCrashlytics('$prefix: $message', error, stackTrace);
  }

  static void logCriticalError(dynamic error, [StackTrace? stackTrace]) {
    log(
      LogLevel.critical,
      'Kritik hata oluştu',
      error: error,
      stackTrace: stackTrace,
    );
    unawaited(
      getIt<FirebaseService>().recordError(
        error,
        stackTrace,
        reason: 'Kritik hata oluştu',
      ),
    );
  }

  static void _logToCrashlytics(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    final firebaseService = getIt<FirebaseService>();
    unawaited(firebaseService.crashlyticsLog(message));
    if (error != null) {
      unawaited(firebaseService.crashlyticsLog('ERROR: $error'));
    }
    if (stackTrace != null) {
      unawaited(firebaseService.crashlyticsLog('STACKTRACE: $stackTrace'));
    }
  }
}
