import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/transaction_receipt.dart';
import 'package:uskudar_mobile/domain/repositories/transactions_repository.dart';

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
