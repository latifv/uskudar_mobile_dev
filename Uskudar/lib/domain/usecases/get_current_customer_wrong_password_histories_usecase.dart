import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/wrong_password_history.dart';
import 'package:payinall/domain/repositories/wrong_login_attempts_repository.dart';

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
