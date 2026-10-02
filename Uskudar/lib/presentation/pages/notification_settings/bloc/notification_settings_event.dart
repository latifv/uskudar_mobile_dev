part of 'notification_settings_bloc.dart';

sealed class NotificationSettingsEvent {
  const NotificationSettingsEvent();
}

final class NotificationSettingsLoadData extends NotificationSettingsEvent {
  const NotificationSettingsLoadData({required this.currentNotificationTypeId});
  final int currentNotificationTypeId;
}

final class NotificationSettingsSelect extends NotificationSettingsEvent {
  const NotificationSettingsSelect({required this.type});
  final NotificationType type;
}

final class NotificationSettingsError extends NotificationSettingsEvent {
  const NotificationSettingsError({required this.message});
  final String message;
}

final class NotificationSettingsResetOperationState
    extends NotificationSettingsEvent {
  const NotificationSettingsResetOperationState();
}
