import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/last_login.dart';
import 'package:uskudar_mobile/domain/repositories/login_attempts_repository.dart';

final class GetLastLoginUsecase
    implements BaseUsecaseWithoutParams<List<LastLogin>> {
  GetLastLoginUsecase(this.repository);

  final LoginAttemptsRepository repository;

  @override
  Future<Either<Failure, List<LastLogin>>> call() async {
    final result = await repository.getLastLogin();
    return result;
  }
}
