import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/notification/bloc/notification_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin NotificationMixin<T extends StatefulWidget> on State<T> {
  late final NotificationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<NotificationBloc>();
    loadNotifications();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadNotifications() {
    bloc.add(const NotificationLoadData());
  }

  void refreshNotifications() {
    bloc.add(const NotificationRefreshData());
  }

  void deleteNotification(String notificationId) {
    bloc.add(NotificationDelete(notificationId: notificationId));
    ToastComponent.showTopToastMessage(
      context: context,
      message: LocaleKeys.notification_deleted.translate,
    );
  }

  void clearAllNotifications() {
    bloc.add(const NotificationClearAll());
    ToastComponent.showTopToastMessage(
      context: context,
      message: LocaleKeys.all_notifications_deleted.translate,
    );
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${LocaleKeys.minutes_ago.translate}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${LocaleKeys.hours_ago.translate}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${LocaleKeys.days_ago.translate}';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}
