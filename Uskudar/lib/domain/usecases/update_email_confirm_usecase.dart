import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/update_email_confirm_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

final class UpdateEmailConfirmUsecase
    implements BaseUsecase<String, UpdateEmailConfirmParams> {
  UpdateEmailConfirmUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, String>> call(
    UpdateEmailConfirmParams params,
  ) async {
    return repository.updateEmailConfirm(params);
  }
}
