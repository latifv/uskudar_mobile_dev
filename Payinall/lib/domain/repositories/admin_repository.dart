import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/admin_commission_summary.dart';
import 'package:payinall/domain/entities/admin_deposit_transfer_summary.dart';
import 'package:payinall/domain/entities/admin_merchant_count_summary.dart';
import 'package:payinall/domain/entities/admin_user_count_summary.dart';
import 'package:payinall/domain/entities/admin_wallet_transfer_summary.dart';
import 'package:payinall/domain/entities/admin_withdraw_transfer_summary.dart';
import 'package:payinall/domain/params/admin_commission_summary_params.dart';
import 'package:payinall/domain/params/admin_deposit_transfer_summary_params.dart';
import 'package:payinall/domain/params/admin_merchant_count_params.dart';
import 'package:payinall/domain/params/admin_user_count_params.dart';
import 'package:payinall/domain/params/admin_wallet_transfer_summary_params.dart';
import 'package:payinall/domain/params/admin_withdraw_transfer_summary_params.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, AdminUserCountSummary>> getUserCount(
    AdminUserCountParams params,
  );

  Future<Either<Failure, AdminMerchantCountSummary>> getMerchantCount(
    AdminMerchantCountParams params,
  );

  Future<Either<Failure, AdminCommissionSummary>> getCommissionSummary(
    AdminCommissionSummaryParams params,
  );

  Future<Either<Failure, AdminWalletTransferSummary>> getWalletTransferSummary(
    AdminWalletTransferSummaryParams params,
  );

  Future<Either<Failure, AdminDepositTransferSummary>>
  getDepositTransferSummary(
    AdminDepositTransferSummaryParams params,
  );

  Future<Either<Failure, AdminWithdrawTransferSummary>>
  getWithdrawTransferSummary(
    AdminWithdrawTransferSummaryParams params,
  );
}
