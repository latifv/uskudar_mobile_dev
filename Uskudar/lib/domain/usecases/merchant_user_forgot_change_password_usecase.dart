import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/merchant_user_forgot_change_password_params.dart';
import 'package:payinall/domain/repositories/passwords_repository.dart';

final class MerchantUserForgotChangePasswordUsecase
    implements BaseUsecase<void, MerchantUserForgotChangePasswordParams> {
  MerchantUserForgotChangePasswordUsecase(this.repository);

  final PasswordsRepository repository;

  @override
  Future<Either<Failure, void>> call(
    MerchantUserForgotChangePasswordParams params,
  ) async {
    final result = await repository.merchantUserForgotChangePassword(params);
    return result;
  }
}
