import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/update_email_send_code_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

final class UpdateEmailSendCodeUsecase
    implements BaseUsecase<String, UpdateEmailSendCodeParams> {
  UpdateEmailSendCodeUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, String>> call(
    UpdateEmailSendCodeParams params,
  ) async {
    return repository.updateEmailSendCode(params);
  }
}
