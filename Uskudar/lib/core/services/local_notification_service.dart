import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';

abstract interface class LocalNotificationService {
  Future<void> initialize();
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  });
  Future<void> dispose();
}

final class LocalNotificationServiceImpl implements LocalNotificationService {
  LocalNotificationServiceImpl() {
    unawaited(_initialize());
  }

  late final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<void> _initialize() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await initialize();
  }

  @override
  Future<void> initialize() async {
    try {
      const androidInitializationSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const iosInitializationSettings = DarwinInitializationSettings();

      const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();

      LogHelper.log(
        LogLevel.debug,
        'Local Notification Service başlatıldı',
      );
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.error,
        'Local Notification Service başlatılamadı: $e',
      );
    }
  }

  @override
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      const androidNotificationDetails = AndroidNotificationDetails(
        'foreground_channel',
        'Foreground Notifications',
        channelDescription: 'Uygulama açıkken gelen bildirimler',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const iosNotificationDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        notificationDetails,
        payload: data?.toString(),
      );

      LogHelper.log(
        LogLevel.debug,
        'Local notification gösterildi: $title - $body',
      );
    } on Exception catch (e) {
      LogHelper.log(
        LogLevel.error,
        'Local notification gösterilemedi: $e',
      );
    }
  }

  void _onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    LogHelper.log(
      LogLevel.debug,
      'Notification tıklandı: ${notificationResponse.payload}',
    );
  }

  @override
  Future<void> dispose() async {
    LogHelper.log(LogLevel.debug, 'Local Notification Service dispose edildi');
  }
}
