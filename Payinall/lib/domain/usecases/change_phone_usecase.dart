import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/change_phone_params.dart';
import 'package:payinall/domain/repositories/user_phone_changes_repository.dart';

final class ChangePhoneUsecase
    implements BaseUsecase<String, ChangePhoneParams> {
  ChangePhoneUsecase(this.repository);

  final UserPhoneChangesRepository repository;

  @override
  Future<Either<Failure, String>> call(ChangePhoneParams params) async {
    final result = await repository.changePhone(params);
    return result;
  }
}
