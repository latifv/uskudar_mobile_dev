import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/wallet_transfer.dart';
import 'package:uskudar_mobile/domain/entities/withdraw_transfer.dart';
import 'package:uskudar_mobile/domain/params/merchant_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/merchant_withdraw_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/wallet_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/withdraw_transfer_params.dart';

abstract interface class TransfersRepository {
  Future<Either<Failure, WalletTransfer>> walletTransfer(
    WalletTransferParams params,
  );
  Future<Either<Failure, String>> walletTransferComplete(String transactionId);
  Future<Either<Failure, WalletTransfer>> merchantTransfer(
    MerchantTransferParams params,
  );
  Future<Either<Failure, WithdrawTransfer>> withdrawTransfer(
    WithdrawTransferParams params,
  );
  Future<Either<Failure, String>> withdrawTransferComplete(
    String transactionId,
  );
  Future<Either<Failure, WithdrawTransfer>> withdrawMerchantTransfer(
    MerchantWithdrawTransferParams params,
  );
  Future<Either<Failure, String>> merchantWithdrawTransferComplete(
    String transactionId,
  );
}
