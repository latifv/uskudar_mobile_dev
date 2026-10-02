import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/customer_process.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';
import 'package:uskudar_mobile/domain/entities/transaction_receipt.dart';
import 'package:uskudar_mobile/domain/params/transactions_params.dart';

abstract interface class TransactionsRepository {
  Future<Either<Failure, List<Transaction>>> getLastTransactions(int dataSize);
  Future<Either<Failure, List<Transaction>>> getMerchantLastTransactions(
    int dataSize,
  );
  Future<Either<Failure, List<Transaction>>> getTransactions(
    TransactionsParams params,
  );
  Future<Either<Failure, List<Transaction>>> getMerchantUserTransactions(
    TransactionsParams params,
  );
  Future<Either<Failure, TransactionReceipt>> getTransactionReceipt(
    String transactionId,
  );
  Future<Either<Failure, List<CustomerProcess>>> getCustomerProcessList();
  Future<Either<Failure, List<CustomerProcess>>> getMerchantProcessList();
}
