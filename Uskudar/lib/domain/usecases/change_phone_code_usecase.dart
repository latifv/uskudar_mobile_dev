import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/data_with_message.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/change_phone_code_params.dart';
import 'package:uskudar_mobile/domain/repositories/user_phone_changes_repository.dart';

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
