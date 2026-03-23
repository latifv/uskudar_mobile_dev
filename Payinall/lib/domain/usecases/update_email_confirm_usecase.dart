import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/update_email_confirm_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

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
