import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/merchant_user_forgot_password_params.dart';
import 'package:uskudar_mobile/domain/repositories/passwords_repository.dart';

final class MerchantUserForgotPasswordUsecase
    implements BaseUsecase<String, MerchantUserForgotPasswordParams> {
  MerchantUserForgotPasswordUsecase(this.repository);

  final PasswordsRepository repository;

  @override
  Future<Either<Failure, String>> call(
    MerchantUserForgotPasswordParams params,
  ) async {
    final result = await repository.merchantUserForgotPassword(params);
    return result;
  }
}
