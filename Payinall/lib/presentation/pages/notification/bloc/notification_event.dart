part of 'notification_bloc.dart';

sealed class NotificationEvent {
  const NotificationEvent();
}

final class NotificationLoadData extends NotificationEvent {
  const NotificationLoadData();
}

final class NotificationRefreshData extends NotificationEvent {
  const NotificationRefreshData();
}

final class NotificationDelete extends NotificationEvent {
  const NotificationDelete({required this.notificationId});
  final String notificationId;
}

final class NotificationClearAll extends NotificationEvent {
  const NotificationClearAll();
}
