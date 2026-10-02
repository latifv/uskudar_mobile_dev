import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

final class ChangeNotificationUsecase implements BaseUsecase<void, int> {
  ChangeNotificationUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(int notificationTypeId) async {
    final result = await repository.changeNotification(notificationTypeId);
    return result;
  }
}
