import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/forgot_password_params.dart';
import 'package:uskudar_mobile/domain/repositories/passwords_repository.dart';

final class ForgotPasswordUsecase
    implements BaseUsecase<String, ForgotPasswordParams> {
  ForgotPasswordUsecase(this.repository);

  final PasswordsRepository repository;

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) async {
    final result = await repository.forgotPassword(params);
    return result;
  }
}
