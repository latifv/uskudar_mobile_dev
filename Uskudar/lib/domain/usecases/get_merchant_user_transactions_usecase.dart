import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';
import 'package:uskudar_mobile/domain/params/transactions_params.dart';
import 'package:uskudar_mobile/domain/repositories/transactions_repository.dart';

final class GetMerchantUserTransactionsUsecase
    implements BaseUsecase<List<Transaction>, TransactionsParams> {
  GetMerchantUserTransactionsUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(
    TransactionsParams params,
  ) async {
    final result = await repository.getMerchantUserTransactions(params);
    return result;
  }
}
