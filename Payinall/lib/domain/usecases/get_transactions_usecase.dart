import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/domain/params/transactions_params.dart';
import 'package:payinall/domain/repositories/transactions_repository.dart';

final class GetTransactionsUsecase
    implements BaseUsecase<List<Transaction>, TransactionsParams> {
  GetTransactionsUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(
    TransactionsParams params,
  ) async {
    final result = await repository.getTransactions(params);
    return result;
  }
}
