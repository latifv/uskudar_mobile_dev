import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/logged_in.dart';
import 'package:payinall/domain/repositories/auth_repository.dart';

final class GetLoggedInUsecase implements BaseUsecaseWithoutParams<LoggedIn?> {
  GetLoggedInUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, LoggedIn?>> call() async {
    final result = await repository.getLoggedIn();
    return result;
  }
}
