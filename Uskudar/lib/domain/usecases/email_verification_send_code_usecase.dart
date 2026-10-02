import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

final class EmailVerificationSendCodeUsecase
    implements BaseUsecaseWithoutParams<String> {
  EmailVerificationSendCodeUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, String>> call() async {
    return repository.emailVerificationSendCode();
  }
}
