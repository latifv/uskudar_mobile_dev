import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/logged_in.dart';
import 'package:payinall/domain/repositories/auth_repository.dart';

final class SaveLoggedInUsecase implements BaseUsecase<void, LoggedIn> {
  SaveLoggedInUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(LoggedIn loggedIn) async {
    final result = await repository.saveLoggedIn(loggedIn);
    return result;
  }
}
