import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/customer_process.dart';
import 'package:payinall/domain/repositories/transactions_repository.dart';

final class GetCustomerProcessListUsecase
    implements BaseUsecaseWithoutParams<List<CustomerProcess>> {
  GetCustomerProcessListUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, List<CustomerProcess>>> call() async {
    final result = await repository.getCustomerProcessList();
    return result;
  }
}
