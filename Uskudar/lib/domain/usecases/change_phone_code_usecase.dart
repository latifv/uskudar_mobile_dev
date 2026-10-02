import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/data_with_message.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/change_phone_code_params.dart';
import 'package:payinall/domain/repositories/user_phone_changes_repository.dart';

final class ChangePhoneCodeUsecase
    implements BaseUsecase<DataWithMessage<String>, ChangePhoneCodeParams> {
  ChangePhoneCodeUsecase(this.repository);

  final UserPhoneChangesRepository repository;

  @override
  Future<Either<Failure, DataWithMessage<String>>> call(
    ChangePhoneCodeParams params,
  ) async {
    final result = await repository.changePhoneCode(params);
    return result;
  }
}
