import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';
import 'package:uskudar_mobile/domain/repositories/transactions_repository.dart';

final class GetLastTransactionsUsecase
    implements BaseUsecase<List<Transaction>, int> {
  GetLastTransactionsUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(int dataSize) async {
    final result = await repository.getLastTransactions(dataSize);
    return result;
  }
}
