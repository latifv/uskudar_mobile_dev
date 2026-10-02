import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/transfers_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/merchant_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/merchant_withdraw_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/wallet_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/withdraw_transfer_request.dart';
import 'package:uskudar_mobile/data/models/wallet_transfer_model.dart';
import 'package:uskudar_mobile/data/models/withdraw_transfer_model.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/entities/withdraw_transfer.dart';
import 'package:uskudar_mobile/domain/params/merchant_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/merchant_withdraw_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/wallet_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/withdraw_transfer_params.dart';
import 'package:uskudar_mobile/domain/repositories/transfers_repository.dart';

final class TransfersRepositoryImpl implements TransfersRepository {
  TransfersRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final TransfersRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, WalletTransfer>> walletTransfer(
    WalletTransferParams params,
  ) async {
    return _dataSourceHandler.handle<WalletTransfer, WalletTransferModel>(
      remoteFunction: () async {
        final request = WalletTransferRequest.fromParams(params);
        final result = await remoteDataSource.walletTransfer(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, WalletTransfer>> merchantTransfer(
    MerchantTransferParams params,
  ) async {
    return _dataSourceHandler.handle<WalletTransfer, WalletTransferModel>(
      remoteFunction: () async {
        final request = MerchantTransferRequest.fromParams(params);
        final result = await remoteDataSource.merchantTransfer(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> walletTransferComplete(
    String transactionId,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.walletTransferComplete(
          transactionId,
        );
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, WithdrawTransfer>> withdrawTransfer(
    WithdrawTransferParams params,
  ) async {
    return _dataSourceHandler.handle<WithdrawTransfer, WithdrawTransferModel>(
      remoteFunction: () async {
        final request = WithdrawTransferRequest.fromParams(params);
        final result = await remoteDataSource.withdrawTransfer(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> withdrawTransferComplete(
    String transactionId,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.withdrawTransferComplete(
          transactionId,
        );
        return result;
      },
      onlyMessage: true,
    );
  }

  @override
  Future<Either<Failure, WithdrawTransfer>> withdrawMerchantTransfer(
    MerchantWithdrawTransferParams params,
  ) async {
    return _dataSourceHandler.handle<WithdrawTransfer, WithdrawTransferModel>(
      remoteFunction: () async {
        final request = MerchantWithdrawTransferRequest.fromParams(params);
        final result = await remoteDataSource.withdrawMerchantTransfer(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, String>> merchantWithdrawTransferComplete(
    String transactionId,
  ) async {
    return _dataSourceHandler.handle<String, void>(
      remoteFunction: () async {
        final result = await remoteDataSource.merchantWithdrawTransferComplete(
          transactionId,
        );
        return result;
      },
      onlyMessage: true,
    );
  }
}
