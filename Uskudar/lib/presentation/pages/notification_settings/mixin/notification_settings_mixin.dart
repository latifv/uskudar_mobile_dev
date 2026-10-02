import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/notification_setting.dart';
import 'package:uskudar_mobile/presentation/pages/notification_settings/bloc/notification_settings_bloc.dart';

mixin NotificationSettingsMixin<T extends StatefulWidget> on State<T> {
  late final NotificationSettingsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<NotificationSettingsBloc>();
    loadSettings();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadSettings() {
    bloc.add(
      NotificationSettingsLoadData(
        currentNotificationTypeId: bloc.userInfoManager.notificationTypeId ?? 0,
      ),
    );
  }

  void selectNotificationType(BuildContext context, NotificationType type) {
    bloc.add(NotificationSettingsSelect(type: type));
  }
}
