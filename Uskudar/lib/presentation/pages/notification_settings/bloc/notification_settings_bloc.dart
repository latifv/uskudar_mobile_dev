import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/notification_setting.dart';
import 'package:payinall/domain/usecases/change_notification_usecase.dart';

part 'notification_settings_event.dart';
part 'notification_settings_state.dart';

final class NotificationSettingsBloc
    extends Bloc<NotificationSettingsEvent, NotificationSettingsState> {
  NotificationSettingsBloc({
    required this.changeNotificationUsecase,
    required this.userInfoManager,
  }) : super(const NotificationSettingsState()) {
    on<NotificationSettingsLoadData>(_loadData);
    on<NotificationSettingsSelect>(_selectNotificationType);
    on<NotificationSettingsError>(_onError);
    on<NotificationSettingsResetOperationState>(_resetOperationState);
  }

  final ChangeNotificationUsecase changeNotificationUsecase;
  final UserInfoManager userInfoManager;

  void _loadData(
    NotificationSettingsLoadData event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(state.copyWith(state: NotificationSettingsBlocState.loading));

    final settings = _getNotificationSettings(event.currentNotificationTypeId);

    emit(
      state.copyWith(
        state: NotificationSettingsBlocState.loaded,
        settings: settings,
      ),
    );
  }

  Future<void> _selectNotificationType(
    NotificationSettingsSelect event,
    Emitter<NotificationSettingsState> emit,
  ) async {
    if (state.state == NotificationSettingsBlocState.loaded) {
      final updatedSettings = state.settings!.map((setting) {
        if (setting.type == event.type) {
          return NotificationSettingModel(
            type: setting.type,
            isSelected: !setting.isSelected,
          );
        }
        return setting;
      }).toList();

      emit(
        state.copyWith(
          settings: updatedSettings,
        ),
      );

      final notificationTypeId = _calculateNotificationTypeId(updatedSettings);
      await _updateNotificationTypeSetting(notificationTypeId, emit);
    }
  }

  Future<void> _updateNotificationTypeSetting(
    int notificationTypeId,
    Emitter<NotificationSettingsState> emit,
  ) async {
    emit(state.copyWith(state: NotificationSettingsBlocState.loading));
    final result = await changeNotificationUsecase(notificationTypeId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            operationState: NotificationOperationState.error,
            state: NotificationSettingsBlocState.loaded,
            message: failure.message,
          ),
        );
      },
      (_) {
        userInfoManager.setNotificationTypeId(notificationTypeId);
        emit(
          state.copyWith(
            operationState: NotificationOperationState.success,
            state: NotificationSettingsBlocState.loaded,
          ),
        );
      },
    );
  }

  void _onError(
    NotificationSettingsError event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(
      state.copyWith(
        state: NotificationSettingsBlocState.error,
        message: event.message,
      ),
    );
  }

  void _resetOperationState(
    NotificationSettingsResetOperationState event,
    Emitter<NotificationSettingsState> emit,
  ) {
    emit(state.copyWith(operationState: null));
  }

  List<NotificationSettingModel> _getNotificationSettings(
    int currentNotificationTypeId,
  ) {
    final isSmsEnabled =
        currentNotificationTypeId == NotificationType.sms.key ||
        currentNotificationTypeId == NotificationType.all.key;
    final isMailEnabled =
        currentNotificationTypeId == NotificationType.mail.key ||
        currentNotificationTypeId == NotificationType.all.key;
    final isFirebaseEnabled =
        currentNotificationTypeId == NotificationType.firebase.key ||
        currentNotificationTypeId == NotificationType.all.key;

    return [
      NotificationSettingModel(
        type: NotificationType.sms,
        isSelected: isSmsEnabled,
      ),
      NotificationSettingModel(
        type: NotificationType.mail,
        isSelected: isMailEnabled,
      ),
      NotificationSettingModel(
        type: NotificationType.firebase,
        isSelected: isFirebaseEnabled,
      ),
    ];
  }

  int _calculateNotificationTypeId(
    List<NotificationSettingModel> settings,
  ) {
    final isSmsEnabled = settings
        .firstWhere((s) => s.type == NotificationType.sms)
        .isSelected;
    final isMailEnabled = settings
        .firstWhere((s) => s.type == NotificationType.mail)
        .isSelected;
    final isFirebaseEnabled = settings
        .firstWhere((s) => s.type == NotificationType.firebase)
        .isSelected;

    final enabledCount = [
      isSmsEnabled,
      isMailEnabled,
      isFirebaseEnabled,
    ].where((enabled) => enabled).length;

    if (enabledCount == 0) {
      return NotificationType.none.key;
    } else if (enabledCount == 1) {
      if (isSmsEnabled) return NotificationType.sms.key;
      if (isMailEnabled) return NotificationType.mail.key;
      if (isFirebaseEnabled) return NotificationType.firebase.key;
    }

    return NotificationType.all.key;
  }
}
