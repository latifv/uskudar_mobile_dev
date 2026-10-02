import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/send_new_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/customer_activations_repository.dart';

final class SendNewCodeUsecase
    implements BaseUsecase<DataWithMessage<String>, SendNewCodeParams> {
  SendNewCodeUsecase(this.repository);

  final CustomerActivationsRepository repository;

  @override
  Future<Either<Failure, DataWithMessage<String>>> call(
    SendNewCodeParams params,
  ) async {
    final result = await repository.sendNewCode(params);
    return result;
  }
}
