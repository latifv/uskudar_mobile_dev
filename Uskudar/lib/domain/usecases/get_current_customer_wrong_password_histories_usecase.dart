import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/wrong_password_history.dart';
import 'package:uskudar_mobile/domain/repositories/wrong_login_attempts_repository.dart';

final class GetCurrentCustomerWrongPasswordHistoriesUsecase
    implements BaseUsecaseWithoutParams<List<WrongPasswordHistory>> {
  GetCurrentCustomerWrongPasswordHistoriesUsecase(this.repository);

  final WrongLoginAttemptsRepository repository;

  @override
  Future<Either<Failure, List<WrongPasswordHistory>>> call() async {
    final result = await repository.getCurrentCustomerWrongPasswordHistories();
    return result;
  }
}
