part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

final class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

final class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

final class NotificationLoaded extends NotificationState {
  const NotificationLoaded({required this.notifications});
  final List<NotificationItem> notifications;

  @override
  List<Object?> get props => [notifications];

  bool get hasNotifications => notifications.isNotEmpty;
}

final class NotificationError extends NotificationState {
  const NotificationError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
