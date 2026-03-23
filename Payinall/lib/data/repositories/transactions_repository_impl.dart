import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/transactions_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/transactions_request.dart';
import 'package:payinall/data/models/customer_process_model.dart';
import 'package:payinall/data/models/transaction_model.dart';
import 'package:payinall/data/models/transaction_receipt_model.dart';
import 'package:payinall/domain/entities/customer_process.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/domain/entities/transaction_receipt.dart';
import 'package:payinall/domain/params/transactions_params.dart';
import 'package:payinall/domain/repositories/transactions_repository.dart';

final class TransactionsRepositoryImpl implements TransactionsRepository {
  TransactionsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final TransactionsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<Transaction>>> getLastTransactions(
    int dataSize,
  ) async {
    return _dataSourceHandler.handle<List<Transaction>, List<TransactionModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getLastTransactions(dataSize);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<Transaction>>> getMerchantLastTransactions(
    int dataSize,
  ) async {
    return _dataSourceHandler.handle<List<Transaction>, List<TransactionModel>>(
      remoteFunction: () async {
        final result = await remoteDataSource.getMerchantLastTransactions(
          dataSize,
        );
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions(
    TransactionsParams params,
  ) async {
    return _dataSourceHandler.handle<List<Transaction>, List<TransactionModel>>(
      remoteFunction: () async {
        final request = TransactionsRequest.fromParams(params);
        final result = await remoteDataSource.getTransactions(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, List<Transaction>>> getMerchantUserTransactions(
    TransactionsParams params,
  ) async {
    return _dataSourceHandler.handle<List<Transaction>, List<TransactionModel>>(
      remoteFunction: () async {
        final request = TransactionsRequest.fromParams(params);
        final result = await remoteDataSource.getMerchantUserTransactions(
          request,
        );
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, TransactionReceipt>> getTransactionReceipt(
    String id,
  ) async {
    return _dataSourceHandler
        .handle<TransactionReceipt, TransactionReceiptModel>(
          remoteFunction: () async {
            final result = await remoteDataSource.getTransactionReceipt(id);
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, List<CustomerProcess>>>
  getCustomerProcessList() async {
    return _dataSourceHandler
        .handle<List<CustomerProcess>, List<CustomerProcessModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getCustomerProcessList();
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, List<CustomerProcess>>>
  getMerchantProcessList() async {
    return _dataSourceHandler
        .handle<List<CustomerProcess>, List<CustomerProcessModel>>(
          remoteFunction: () async {
            final result = await remoteDataSource.getMerchantProcessList();
            return result;
          },
          onlyData: true,
        );
  }
}
