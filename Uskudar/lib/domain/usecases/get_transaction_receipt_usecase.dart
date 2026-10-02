import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/transaction_receipt.dart';
import 'package:payinall/domain/repositories/transactions_repository.dart';

final class GetTransactionReceiptUsecase
    implements BaseUsecase<TransactionReceipt, String> {
  GetTransactionReceiptUsecase(this.repository);

  final TransactionsRepository repository;

  @override
  Future<Either<Failure, TransactionReceipt>> call(String params) async {
    final result = await repository.getTransactionReceipt(params);
    return result;
  }
}
