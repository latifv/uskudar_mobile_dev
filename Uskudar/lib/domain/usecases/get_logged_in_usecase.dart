import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/logged_in.dart';
import 'package:uskudar_mobile/domain/repositories/auth_repository.dart';

final class GetLoggedInUsecase implements BaseUsecaseWithoutParams<LoggedIn?> {
  GetLoggedInUsecase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, LoggedIn?>> call() async {
    final result = await repository.getLoggedIn();
    return result;
  }
}
