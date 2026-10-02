import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/current_user_info.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

final class GetCurrentUserInfoUsecase
    implements BaseUsecaseWithoutParams<CurrentUserInfo> {
  GetCurrentUserInfoUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, CurrentUserInfo>> call() async {
    final result = await repository.getCurrentUserInfo();
    return result;
  }
}
