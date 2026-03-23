import 'package:flutter/material.dart';

enum NotificationType {
  transaction,
  promotion,
  system,
  security,
  info;

  IconData get icon {
    switch (this) {
      case NotificationType.transaction:
        return Icons.payments_outlined;
      case NotificationType.promotion:
        return Icons.local_offer_outlined;
      case NotificationType.system:
        return Icons.info_outline;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.transaction:
        return Colors.grey;
      case NotificationType.promotion:
        return Colors.amber;
      case NotificationType.system:
        return Colors.green;
      case NotificationType.security:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
    }
  }
}
