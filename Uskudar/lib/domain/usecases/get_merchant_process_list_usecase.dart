import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/customer_process.dart';
import 'package:uskudar_mobile/domain/repositories/transactions_repository.dart';

final class GetMerchantProcessListUsecase
    implements BaseUsecaseWithoutParams<List<CustomerProcess>> {
  GetMerchantProcessListUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, List<CustomerProcess>>> call() async {
    final result = await repository.getMerchantProcessList();
    return result;
  }
}
