import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/create_register_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_register_code_repository.dart';

final class CreateRegisterCodeUsecase
    implements BaseUsecase<DataWithMessage<String>, CreateRegisterCodeParams> {
  CreateRegisterCodeUsecase(this.repository);

  final CustomerRegisterCodeRepository repository;

  @override
  Future<Either<Failure, DataWithMessage<String>>> call(
    CreateRegisterCodeParams params,
  ) async {
    final result = await repository.createRegisterCode(params);
    return result;
  }
}
