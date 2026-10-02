import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_local_data_source.dart';
import 'package:uskudar_mobile/data/local_storage/hive_boxes.dart';
import 'package:uskudar_mobile/data/local_storage/preferences_keys.dart';
import 'package:uskudar_mobile/data/models/notification_item_model.dart';

abstract interface class NotificationLocalDataSource {
  Future<List<NotificationItemModel>> getNotifications();
  Future<void> saveNotification(NotificationItemModel notification);
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAllNotifications();
}

final class NotificationLocalDataSourceImpl extends BaseLocalDataSource
    implements NotificationLocalDataSource {
  NotificationLocalDataSourceImpl() : super(HiveBoxes.notification);

  @override
  Future<List<NotificationItemModel>> getNotifications() async {
    try {
      final notifications = read<List<dynamic>>(PreferencesKeys.notifications);
      return notifications.cast<NotificationItemModel>();
    } on CacheException {
      return [];
    }
  }

  @override
  Future<void> saveNotification(NotificationItemModel notification) async {
    final notifications = await getNotifications();
    notifications.insert(0, notification);
    await write<List<NotificationItemModel>>(
      PreferencesKeys.notifications,
      notifications,
    );
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final notifications = await getNotifications();
    final updatedNotifications = notifications
        .where((notification) => notification.id != notificationId)
        .toList();
    await write<List<NotificationItemModel>>(
      PreferencesKeys.notifications,
      updatedNotifications,
    );
  }

  @override
  Future<void> clearAllNotifications() async {
    await write<List<NotificationItemModel>>(
      PreferencesKeys.notifications,
      [],
    );
  }
}
