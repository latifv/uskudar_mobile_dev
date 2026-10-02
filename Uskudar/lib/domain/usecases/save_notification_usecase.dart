import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/notification_item.dart';
import 'package:uskudar_mobile/domain/repositories/notification_repository.dart';

final class SaveNotificationUsecase
    implements BaseUsecase<void, NotificationItem> {
  SaveNotificationUsecase(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, void>> call(NotificationItem params) async {
    final result = await repository.saveNotification(params);
    return result;
  }
}
