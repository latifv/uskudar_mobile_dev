import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/logged_in.dart';
import 'package:uskudar_mobile/domain/repositories/auth_repository.dart';

final class SaveLoggedInUsecase implements BaseUsecase<void, LoggedIn> {
  SaveLoggedInUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, void>> call(LoggedIn loggedIn) async {
    final result = await repository.saveLoggedIn(loggedIn);
    return result;
  }
}
