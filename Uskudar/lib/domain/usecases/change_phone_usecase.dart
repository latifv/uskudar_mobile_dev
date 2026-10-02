import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/change_phone_params.dart';
import 'package:uskudar_mobile/domain/repositories/user_phone_changes_repository.dart';

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
