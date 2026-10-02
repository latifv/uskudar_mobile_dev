import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

final class EmailVerificationSendCodeUsecase
    implements BaseUsecaseWithoutParams<String> {
  EmailVerificationSendCodeUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, String>> call() async {
    return repository.emailVerificationSendCode();
  }
}
