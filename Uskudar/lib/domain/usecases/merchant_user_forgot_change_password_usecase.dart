import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/merchant_user_forgot_change_password_params.dart';
import 'package:uskudar_mobile/domain/repositories/passwords_repository.dart';

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
