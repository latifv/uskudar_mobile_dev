import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/email_verification_confirm_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

final class EmailVerificationConfirmUsecase
    implements BaseUsecase<String, EmailVerificationConfirmParams> {
  EmailVerificationConfirmUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, String>> call(
    EmailVerificationConfirmParams params,
  ) async {
    return repository.emailVerificationConfirm(params);
  }
}
