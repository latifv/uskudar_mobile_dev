import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/notification_item.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<NotificationItem>>> getNotifications();
  Future<Either<Failure, void>> saveNotification(NotificationItem notification);
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  Future<Either<Failure, void>> clearAllNotifications();
}
