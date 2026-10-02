import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/data/core/data_source_handler.dart';
import 'package:uskudar_mobile/data/datasources/remote/admin_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_commission_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_deposit_transfer_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_merchant_count_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_user_count_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_wallet_transfer_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_withdraw_transfer_summary_request.dart';
import 'package:uskudar_mobile/data/models/admin_commission_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_deposit_transfer_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_merchant_count_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_user_count_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_wallet_transfer_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_withdraw_transfer_summary_model.dart';
import 'package:uskudar_mobile/domain/entities/admin_commission_summary.dart';
import 'package:uskudar_mobile/domain/entities/admin_deposit_transfer_summary.dart';
import 'package:uskudar_mobile/domain/entities/admin_merchant_count_summary.dart';
import 'package:uskudar_mobile/domain/entities/admin_user_count_summary.dart';
import 'package:uskudar_mobile/domain/entities/admin_wallet_transfer_summary.dart';
import 'package:uskudar_mobile/domain/entities/admin_withdraw_transfer_summary.dart';
import 'package:uskudar_mobile/domain/params/admin_commission_summary_params.dart';
import 'package:uskudar_mobile/domain/params/admin_deposit_transfer_summary_params.dart';
import 'package:uskudar_mobile/domain/params/admin_merchant_count_params.dart';
import 'package:uskudar_mobile/domain/params/admin_user_count_params.dart';
import 'package:uskudar_mobile/domain/params/admin_wallet_transfer_summary_params.dart';
import 'package:uskudar_mobile/domain/params/admin_withdraw_transfer_summary_params.dart';
import 'package:uskudar_mobile/domain/repositories/admin_repository.dart';

final class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final AdminRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, AdminUserCountSummary>> getUserCount(
    AdminUserCountParams params,
  ) async {
    return _dataSourceHandler
        .handle<AdminUserCountSummary, AdminUserCountSummaryModel>(
          remoteFunction: () async {
            final request = AdminUserCountRequest.fromParams(params);
            final result = await remoteDataSource.getUserCount(request);
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, AdminMerchantCountSummary>> getMerchantCount(
    AdminMerchantCountParams params,
  ) async {
    return _dataSourceHandler
        .handle<AdminMerchantCountSummary, AdminMerchantCountSummaryModel>(
          remoteFunction: () async {
            final request = AdminMerchantCountRequest.fromParams(params);
            final result = await remoteDataSource.getMerchantCount(request);
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, AdminCommissionSummary>> getCommissionSummary(
    AdminCommissionSummaryParams params,
  ) async {
    return _dataSourceHandler
        .handle<AdminCommissionSummary, AdminCommissionSummaryModel>(
          remoteFunction: () async {
            final request = AdminCommissionSummaryRequest.fromParams(params);
            final result = await remoteDataSource.getCommissionSummary(request);
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, AdminWalletTransferSummary>> getWalletTransferSummary(
    AdminWalletTransferSummaryParams params,
  ) async {
    return _dataSourceHandler.handle<
      AdminWalletTransferSummary,
      AdminWalletTransferSummaryModel
    >(
      remoteFunction: () async {
        final request = AdminWalletTransferSummaryRequest.fromParams(params);
        final result = await remoteDataSource.getWalletTransferSummary(request);
        return result;
      },
      onlyData: true,
    );
  }

  @override
  Future<Either<Failure, AdminDepositTransferSummary>>
  getDepositTransferSummary(
    AdminDepositTransferSummaryParams params,
  ) async {
    return _dataSourceHandler
        .handle<AdminDepositTransferSummary, AdminDepositTransferSummaryModel>(
          remoteFunction: () async {
            final request = AdminDepositTransferSummaryRequest.fromParams(
              params,
            );
            final result = await remoteDataSource.getDepositTransferSummary(
              request,
            );
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, AdminWithdrawTransferSummary>>
  getWithdrawTransferSummary(
    AdminWithdrawTransferSummaryParams params,
  ) async {
    return _dataSourceHandler.handle<
      AdminWithdrawTransferSummary,
      AdminWithdrawTransferSummaryModel
    >(
      remoteFunction: () async {
        final request = AdminWithdrawTransferSummaryRequest.fromParams(params);
        final result = await remoteDataSource.getWithdrawTransferSummary(
          request,
        );
        return result;
      },
      onlyData: true,
    );
  }
}
