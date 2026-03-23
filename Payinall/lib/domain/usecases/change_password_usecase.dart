import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/change_password_params.dart';
import 'package:payinall/domain/repositories/passwords_repository.dart';

final class ChangePasswordUsecase
    implements BaseUsecase<void, ChangePasswordParams> {
  ChangePasswordUsecase(this.repository);

  final PasswordsRepository repository;

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    final result = await repository.changePassword(params);
    return result;
  }
}
