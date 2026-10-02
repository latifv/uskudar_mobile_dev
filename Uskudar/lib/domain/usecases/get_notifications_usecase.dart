import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/notification_item.dart';
import 'package:uskudar_mobile/domain/repositories/notification_repository.dart';

final class GetNotificationsUsecase
    implements BaseUsecase<List<NotificationItem>, void> {
  GetNotificationsUsecase(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, List<NotificationItem>>> call(void params) async {
    final result = await repository.getNotifications();
    return result;
  }
}
