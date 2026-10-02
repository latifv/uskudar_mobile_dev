import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:uskudar_mobile/core/services/local_notification_service.dart';
import 'package:uskudar_mobile/core/utils/log_helper.dart';
import 'package:uskudar_mobile/core/utils/log_level.dart';
import 'package:uskudar_mobile/domain/entities/notification_item.dart';
import 'package:uskudar_mobile/domain/usecases/save_notification_usecase.dart';

abstract interface class FirebaseService {
  Future<String?> getFirebaseToken();

  FirebaseAnalyticsObserver? getAnalyticsObserver();
  Future<void> logEvent(String name, Map<String, Object>? parameters);
  Future<void> setCurrentScreen(String screenName);

  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);

  Future<void> initializeCrashlytics();
  Future<void> setUserIdentifier(String identifier);
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  });
  Future<void> crashlyticsLog(String message);
  Future<void> dispose();
}

final class FirebaseServiceImpl implements FirebaseService {
  FirebaseServiceImpl()
    : _firebaseMessaging = FirebaseMessaging.instance,
      _firebaseAnalytics = FirebaseAnalytics.instance,
      _firebaseCrashlytics = FirebaseCrashlytics.instance {
    _initFuture = _initialize();
  }

  final FirebaseMessaging _firebaseMessaging;
  final FirebaseAnalytics _firebaseAnalytics;
  final FirebaseCrashlytics _firebaseCrashlytics;
  late final Future<void> _initFuture;
  bool _isMessagingReady = false;
  LocalNotificationService? _localNotificationService;
  SaveNotificationUsecase? _saveNotificationUsecase;

  LocalNotificationService get localNotificationService {
    _localNotificationService ??= GetIt.instance<LocalNotificationService>();
    return _localNotificationService!;
  }

  SaveNotificationUsecase get saveNotificationUsecase {
    _saveNotificationUsecase ??= GetIt.instance<SaveNotificationUsecase>();
    return _saveNotificationUsecase!;
  }

  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;

  Future<void> _initialize() async {
    try {
      await _initializeFirebaseMessaging();
      _isMessagingReady = true;
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.warning,
        'Firebase Messaging başlatılamadı: $e',
      );
    }
    await _handleInitialMessage();
    await initializeCrashlytics();
  }

  @override
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {
    await _firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    await _firebaseAnalytics.logScreenView(screenName: screenName);
  }

  @override
  Future<String?> getFirebaseToken() async {
    try {
      await _initFuture;
      if (!_isMessagingReady) return null;
      return await _firebaseMessaging.getToken();
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.warning,
        'Firebase token alınamadı: $e',
      );
      return null;
    }
  }

  @override
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _firebaseAnalytics);
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      await _firebaseMessaging.requestPermission();
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.warning,
        'Firebase bildirim izni alınamadı: $e',
      );
    }
    await _configureForegroundNotifications();
    await _configureOnMessage();

    unawaited(_subscribeToDebugAndPlatformSpecificTopics());
  }

  Future<void> _configureForegroundNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      badge: true,
    );
  }

  Future<void> _configureOnMessage() async {
    _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) {
      LogHelper.log(
        LogLevel.debug,
        'onMessageOpenedApp alındı: ${message.notification?.title}, ${message.notification?.body}',
      );
      _saveNotificationToLocal(message);
    });

    _onMessageSubscription = FirebaseMessaging.onMessage.listen((
      message,
    ) {
      LogHelper.log(
        LogLevel.debug,
        'onMessage alındı: ${message.notification?.title}, ${message.notification?.body}',
      );

      _saveNotificationToLocal(message);

      if (message.notification != null) {
        unawaited(
          localNotificationService.showNotification(
            title: message.notification!.title ?? '',
            body: message.notification!.body ?? '',
            data: message.data,
          ),
        );
      } else if (message.data.isNotEmpty) {
        final title = message.data['title']?.toString() ?? '';
        final body = message.data['body']?.toString() ?? '';

        if (title.isNotEmpty || body.isNotEmpty) {
          unawaited(
            localNotificationService.showNotification(
              title: title,
              body: body,
              data: message.data,
            ),
          );
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _saveNotificationToLocal(RemoteMessage message) {
    var title = '';
    var body = '';

    if (message.notification != null) {
      title = message.notification!.title ?? '';
      body = message.notification!.body ?? '';
    } else if (message.data.isNotEmpty) {
      title = message.data['title']?.toString() ?? '';
      body = message.data['body']?.toString() ?? '';
    }

    if (title.isNotEmpty || body.isNotEmpty) {
      final notification = NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        message: body,
        date: DateTime.now(),
      );

      unawaited(saveNotificationUsecase(notification));
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    LogHelper.log(
      LogLevel.debug,
      'backgroundMessage alındı: ${message.notification?.title}, ${message.notification?.body}',
    );
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    unawaited(_firebaseMessaging.subscribeToTopic(topic));
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    unawaited(_firebaseMessaging.unsubscribeFromTopic(topic));
  }

  Future<void> _handleInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        LogHelper.log(
          LogLevel.debug,
          'initialMessage alındı: ${initialMessage.notification?.title}, ${initialMessage.notification?.body}',
        );
      }
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.warning,
        'Firebase initialMessage alınamadı: $e',
      );
    }
  }

  Future<void> _subscribeToDebugAndPlatformSpecificTopics() async {
    if (kDebugMode) {
      await subscribeToTopic('debug');
    }
    if (kProfileMode) {
      await subscribeToTopic('test');
    }
    if (Platform.isIOS) {
      await subscribeToTopic('ios');
    } else if (Platform.isAndroid) {
      await subscribeToTopic('android');
    }
    if (Platform.isIOS || Platform.isAndroid) {
      await subscribeToTopic('mobile');
    }
    await subscribeToTopic('all');

    LogHelper.log(LogLevel.debug, 'Topic abonelikleri tamamlandı.');
  }

  @override
  Future<void> initializeCrashlytics() async {
    await _firebaseCrashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
    FlutterError.onError = _firebaseCrashlytics.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(_firebaseCrashlytics.recordError(error, stack, fatal: true));
      return true;
    };
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    await _firebaseCrashlytics.setUserIdentifier(identifier);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    if (kReleaseMode) {
      await _firebaseCrashlytics.recordError(exception, stack, reason: reason);
    }
  }

  @override
  Future<void> crashlyticsLog(String message) async {
    if (kReleaseMode) {
      await _firebaseCrashlytics.log(message);
    }
  }

  @override
  Future<void> dispose() async {
    await _onMessageOpenedAppSubscription?.cancel();
    await _onMessageSubscription?.cancel();

    _onMessageOpenedAppSubscription = null;
    _onMessageSubscription = null;

    LogHelper.log(LogLevel.debug, 'Firebase Service dispose edildi');
  }
}

/// Keeps the existing app flows available until a separate Firebase app is supplied.
final class DisabledFirebaseService implements FirebaseService {
  @override
  Future<String?> getFirebaseToken() async => null;

  @override
  FirebaseAnalyticsObserver? getAnalyticsObserver() => null;

  @override
  Future<void> logEvent(String name, Map<String, Object>? parameters) async {}

  @override
  Future<void> setCurrentScreen(String screenName) async {}

  @override
  Future<void> subscribeToTopic(String topic) async {}

  @override
  Future<void> unsubscribeFromTopic(String topic) async {}

  @override
  Future<void> initializeCrashlytics() async {}

  @override
  Future<void> setUserIdentifier(String identifier) async {}

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {}

  @override
  Future<void> crashlyticsLog(String message) async {}

  @override
  Future<void> dispose() async {}
}
