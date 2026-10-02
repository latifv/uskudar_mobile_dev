import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/auth_mobile.dart';
import 'package:uskudar_mobile/domain/params/auth_merchant_params.dart';
import 'package:uskudar_mobile/domain/repositories/auth_repository.dart';

final class AuthMerchantUsecase
    implements BaseUsecase<AuthMobile, AuthMerchantParams> {
  AuthMerchantUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AuthMobile>> call(AuthMerchantParams params) async {
    final result = await repository.authMerchant(params);
    return result;
  }
}
