part of 'notification_settings_bloc.dart';

enum NotificationSettingsBlocState { initial, loading, loaded, error }

enum NotificationOperationState { success, error }

final class NotificationSettingsState extends Equatable {
  const NotificationSettingsState({
    this.key,
    this.state = NotificationSettingsBlocState.initial,
    this.settings,
    this.message,
    this.selectedNotificationType,
    this.operationState,
  });
  final Key? key;
  final NotificationSettingsBlocState state;
  final List<NotificationSettingModel>? settings;
  final String? message;
  final NotificationType? selectedNotificationType;
  final NotificationOperationState? operationState;

  NotificationSettingsState copyWith({
    Key? key,
    NotificationSettingsBlocState? state,
    List<NotificationSettingModel>? settings,
    String? message,
    NotificationType? selectedNotificationType,
    NotificationOperationState? operationState,
  }) {
    return NotificationSettingsState(
      key: key ?? this.key,
      state: state ?? this.state,
      settings: settings ?? this.settings,
      message: message,
      selectedNotificationType:
          selectedNotificationType ?? this.selectedNotificationType,
      operationState: operationState,
    );
  }

  @override
  List<Object?> get props => [
    state,
    settings,
    message,
    key,
    selectedNotificationType,
    operationState,
  ];
}
