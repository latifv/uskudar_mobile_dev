import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/forgot_password_params.dart';
import 'package:payinall/domain/repositories/passwords_repository.dart';

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
