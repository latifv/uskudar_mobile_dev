import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/notification_item.dart';
import 'package:payinall/domain/usecases/clear_all_notifications_usecase.dart';
import 'package:payinall/domain/usecases/delete_notification_usecase.dart';
import 'package:payinall/domain/usecases/get_notifications_usecase.dart';

part 'notification_event.dart';
part 'notification_state.dart';

final class NotificationBloc
    extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc({
    required GetNotificationsUsecase getNotificationsUsecase,
    required DeleteNotificationUsecase deleteNotificationUsecase,
    required ClearAllNotificationsUsecase clearAllNotificationsUsecase,
  }) : _getNotificationsUsecase = getNotificationsUsecase,
       _deleteNotificationUsecase = deleteNotificationUsecase,
       _clearAllNotificationsUsecase = clearAllNotificationsUsecase,
       super(const NotificationInitial()) {
    on<NotificationLoadData>(_onLoadNotificationData);
    on<NotificationRefreshData>(_onRefreshNotificationData);
    on<NotificationDelete>(_onDeleteNotification);
    on<NotificationClearAll>(_onClearAllNotifications);
  }

  final GetNotificationsUsecase _getNotificationsUsecase;
  final DeleteNotificationUsecase _deleteNotificationUsecase;
  final ClearAllNotificationsUsecase _clearAllNotificationsUsecase;

  Future<void> _onLoadNotificationData(
    NotificationLoadData event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await _getNotificationsUsecase(null);

    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }

  Future<void> _onRefreshNotificationData(
    NotificationRefreshData event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _getNotificationsUsecase(null);

    result.fold(
      (failure) => emit(NotificationError(message: failure.message)),
      (notifications) => emit(NotificationLoaded(notifications: notifications)),
    );
  }

  Future<void> _onDeleteNotification(
    NotificationDelete event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is! NotificationLoaded) return;

    final currentState = state as NotificationLoaded;
    final updatedNotifications = currentState.notifications
        .where((notification) => notification.id != event.notificationId)
        .toList();

    emit(NotificationLoaded(notifications: updatedNotifications));

    await _deleteNotificationUsecase(event.notificationId);
  }

  Future<void> _onClearAllNotifications(
    NotificationClearAll event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoaded(notifications: []));

    await _clearAllNotificationsUsecase(null);
  }
}
