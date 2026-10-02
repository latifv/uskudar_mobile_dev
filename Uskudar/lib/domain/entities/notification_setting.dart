import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

enum NotificationType {
  none(0, LocaleKeys.notification_type_none),
  sms(1, LocaleKeys.notification_type_sms),
  mail(2, LocaleKeys.notification_type_mail),
  firebase(3, LocaleKeys.notification_type_firebase),
  all(4, LocaleKeys.notification_type_all);

  const NotificationType(this.key, this.localeKey);
  final int key;
  final String localeKey;

  static NotificationType fromKey(int key) {
    return NotificationType.values.firstWhere(
      (type) => type.key == key,
      orElse: () => NotificationType.none,
    );
  }

  String get title => localeKey.translate;

  IconData get icon {
    switch (this) {
      case NotificationType.none:
        return Icons.block_outlined;
      case NotificationType.sms:
        return Icons.sms_outlined;
      case NotificationType.mail:
        return Icons.email_outlined;
      case NotificationType.firebase:
        return Icons.notifications_outlined;
      case NotificationType.all:
        return Icons.notifications_active_outlined;
    }
  }

  String get description {
    switch (this) {
      case NotificationType.none:
        return LocaleKeys.notification_type_none_description.translate;
      case NotificationType.sms:
        return LocaleKeys.notification_type_sms_description.translate;
      case NotificationType.mail:
        return LocaleKeys.notification_type_mail_description.translate;
      case NotificationType.firebase:
        return LocaleKeys.notification_type_firebase_description.translate;
      case NotificationType.all:
        return LocaleKeys.notification_type_all_description.translate;
    }
  }
}

final class NotificationSettingModel extends Equatable {
  const NotificationSettingModel({
    required this.type,
    required this.isSelected,
  });
  final NotificationType type;
  final bool isSelected;

  NotificationSettingModel copyWith({
    NotificationType? type,
    bool? isSelected,
  }) {
    return NotificationSettingModel(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [type, isSelected];
}
