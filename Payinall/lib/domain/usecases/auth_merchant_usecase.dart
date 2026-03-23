import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/auth_mobile.dart';
import 'package:payinall/domain/params/auth_merchant_params.dart';
import 'package:payinall/domain/repositories/auth_repository.dart';

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
