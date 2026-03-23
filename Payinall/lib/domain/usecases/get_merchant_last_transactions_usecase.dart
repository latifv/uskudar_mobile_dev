import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/domain/repositories/transactions_repository.dart';

final class GetMerchantLastTransactionsUsecase
    implements BaseUsecase<List<Transaction>, int> {
  GetMerchantLastTransactionsUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(int dataSize) async {
    final result = await repository.getMerchantLastTransactions(dataSize);
    return result;
  }
}
