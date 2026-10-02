import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/metropol_user_balance.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class GetMetropolUserBalanceUsecase
    implements BaseUsecaseWithoutParams<MetropolUserBalance> {
  GetMetropolUserBalanceUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, MetropolUserBalance>> call() async {
    return repository.getUserBalance();
  }
}
