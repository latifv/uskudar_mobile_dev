import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/notification_repository.dart';

final class ClearAllNotificationsUsecase implements BaseUsecase<void, void> {
  ClearAllNotificationsUsecase(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, void>> call(void params) async {
    final result = await repository.clearAllNotifications();
    return result;
  }
}
