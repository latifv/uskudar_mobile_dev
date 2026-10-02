import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/check_register_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_register_code_repository.dart';

final class CheckRegisterCodeUsecase
    implements BaseUsecase<String, CheckRegisterCodeParams> {
  CheckRegisterCodeUsecase(this.repository);

  final CustomerRegisterCodeRepository repository;

  @override
  Future<Either<Failure, String>> call(CheckRegisterCodeParams params) async {
    final result = await repository.checkRegisterCode(params);
    return result;
  }
}
