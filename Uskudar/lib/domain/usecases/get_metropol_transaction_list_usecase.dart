import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/metropol_transaction.dart';
import 'package:uskudar_mobile/domain/params/metropol_transaction_list_params.dart';
import 'package:uskudar_mobile/domain/repositories/metropols_repository.dart';

final class GetMetropolTransactionListUsecase
    implements
        BaseUsecase<List<MetropolTransaction>, MetropolTransactionListParams> {
  GetMetropolTransactionListUsecase(this.repository);

  final MetropolsRepository repository;

  @override
  Future<Either<Failure, List<MetropolTransaction>>> call(
    MetropolTransactionListParams params,
  ) async {
    return repository.getTransactionList(params);
  }
}
