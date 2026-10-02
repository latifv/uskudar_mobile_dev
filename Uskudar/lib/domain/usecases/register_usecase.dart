import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/register_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

final class RegisterUsecase implements BaseUsecase<void, RegisterParams> {
  RegisterUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    final result = await repository.register(params);
    return result;
  }
}
