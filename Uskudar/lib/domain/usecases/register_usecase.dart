import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/register_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

final class RegisterUsecase implements BaseUsecase<void, RegisterParams> {
  RegisterUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, void>> call(RegisterParams params) async {
    final result = await repository.register(params);
    return result;
  }
}
