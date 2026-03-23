import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/send_new_code_params.dart';
import 'package:payinall/domain/repositories/customer_activations_repository.dart';

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
