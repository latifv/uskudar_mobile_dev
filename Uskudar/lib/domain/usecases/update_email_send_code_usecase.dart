import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/update_email_send_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

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
