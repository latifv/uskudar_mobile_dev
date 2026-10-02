import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/forgot_change_password_params.dart';
import 'package:uskudar_mobile/domain/repositories/passwords_repository.dart';

final class ForgotChangePasswordUsecase
    implements BaseUsecase<void, ForgotChangePasswordParams> {
  ForgotChangePasswordUsecase(this.repository);

  final PasswordsRepository repository;

  @override
  Future<Either<Failure, void>> call(ForgotChangePasswordParams params) async {
    final result = await repository.forgotChangePassword(params);
    return result;
  }
}
