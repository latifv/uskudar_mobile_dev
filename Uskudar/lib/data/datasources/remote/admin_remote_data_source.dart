import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_commission_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_deposit_transfer_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_merchant_count_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_user_count_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_wallet_transfer_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/admin_withdraw_transfer_summary_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_commission_summary_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_deposit_transfer_summary_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_merchant_count_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_user_count_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_wallet_transfer_summary_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/admin_withdraw_transfer_summary_response.dart';
import 'package:uskudar_mobile/data/models/admin_commission_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_deposit_transfer_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_merchant_count_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_user_count_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_wallet_transfer_summary_model.dart';
import 'package:uskudar_mobile/data/models/admin_withdraw_transfer_summary_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class AdminRemoteDataSource {
  Future<NetworkResponse<AdminUserCountSummaryModel>> getUserCount(
    AdminUserCountRequest request,
  );

  Future<NetworkResponse<AdminMerchantCountSummaryModel>> getMerchantCount(
    AdminMerchantCountRequest request,
  );

  Future<NetworkResponse<AdminCommissionSummaryModel>> getCommissionSummary(
    AdminCommissionSummaryRequest request,
  );

  Future<NetworkResponse<AdminWalletTransferSummaryModel>>
  getWalletTransferSummary(
    AdminWalletTransferSummaryRequest request,
  );

  Future<NetworkResponse<AdminDepositTransferSummaryModel>>
  getDepositTransferSummary(
    AdminDepositTransferSummaryRequest request,
  );

  Future<NetworkResponse<AdminWithdrawTransferSummaryModel>>
  getWithdrawTransferSummary(
    AdminWithdrawTransferSummaryRequest request,
  );
}

final class AdminRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AdminRemoteDataSource {
  AdminRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<AdminUserCountSummaryModel>> getUserCount(
    AdminUserCountRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.userCount,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AdminUserCountResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AdminUserCountResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AdminUserCountSummaryModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AdminMerchantCountSummaryModel>> getMerchantCount(
    AdminMerchantCountRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.merchantCount,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AdminMerchantCountResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AdminMerchantCountResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AdminMerchantCountSummaryModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AdminCommissionSummaryModel>> getCommissionSummary(
    AdminCommissionSummaryRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.commissionSummary,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AdminCommissionSummaryResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AdminCommissionSummaryResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AdminCommissionSummaryModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AdminWalletTransferSummaryModel>>
  getWalletTransferSummary(
    AdminWalletTransferSummaryRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.walletTransferSummary,
      data: request.toJson(),
    );

    final response =
        NetworkResponse.fromJson<AdminWalletTransferSummaryResponse>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is Map<String, dynamic>) {
              return AdminWalletTransferSummaryResponse.fromJson(json);
            }
            throw const MappingException();
          },
        );

    return response.map(AdminWalletTransferSummaryModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AdminDepositTransferSummaryModel>>
  getDepositTransferSummary(
    AdminDepositTransferSummaryRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.depositTransferSummary,
      data: request.toJson(),
    );

    final response =
        NetworkResponse.fromJson<AdminDepositTransferSummaryResponse>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is Map<String, dynamic>) {
              return AdminDepositTransferSummaryResponse.fromJson(json);
            }
            throw const MappingException();
          },
        );

    return response.map(AdminDepositTransferSummaryModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AdminWithdrawTransferSummaryModel>>
  getWithdrawTransferSummary(
    AdminWithdrawTransferSummaryRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.withDrawTransferSummary,
      data: request.toJson(),
    );

    final response =
        NetworkResponse.fromJson<AdminWithdrawTransferSummaryResponse>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is Map<String, dynamic>) {
              return AdminWithdrawTransferSummaryResponse.fromJson(json);
            }
            throw const MappingException();
          },
        );

    return response.map(AdminWithdrawTransferSummaryModel.fromResponse);
  }
}
