import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/auth_token.dart';
import 'package:payinall/domain/params/check_merchant_activation_code_params.dart';
import 'package:payinall/domain/repositories/customer_activations_repository.dart';

final class CheckMerchantActivationCodeUsecase
    implements BaseUsecase<AuthToken, CheckMerchantActivationCodeParams> {
  CheckMerchantActivationCodeUsecase(this.repository);

  final CustomerActivationsRepository repository;

  @override
  Future<Either<Failure, AuthToken>> call(
    CheckMerchantActivationCodeParams params,
  ) async {
    final result = await repository.checkMerchantActivationCode(params);
    return result;
  }
}
