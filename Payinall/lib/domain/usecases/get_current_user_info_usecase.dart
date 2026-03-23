import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/current_user_info.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

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
