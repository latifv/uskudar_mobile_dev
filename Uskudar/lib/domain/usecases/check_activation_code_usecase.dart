import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/auth_token.dart';
import 'package:uskudar_mobile/domain/params/check_activation_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_activations_repository.dart';

final class CheckActivationCodeUsecase
    implements BaseUsecase<AuthToken, CheckActivationCodeParams> {
  CheckActivationCodeUsecase(this.repository);

  final CustomerActivationsRepository repository;

  @override
  Future<Either<Failure, AuthToken>> call(
    CheckActivationCodeParams params,
  ) async {
    final result = await repository.checkActivationCode(params);
    return result;
  }
}
