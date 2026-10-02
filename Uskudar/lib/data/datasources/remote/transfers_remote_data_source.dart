import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/merchant_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/merchant_withdraw_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/wallet_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/withdraw_transfer_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/wallet_transfer_response.dart';
import 'package:uskudar_mobile/data/dtos/responses/withdraw_transfer_response.dart';
import 'package:uskudar_mobile/data/models/wallet_transfer_model.dart';
import 'package:uskudar_mobile/data/models/withdraw_transfer_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class TransfersRemoteDataSource {
  Future<NetworkResponse<WalletTransferModel>> walletTransfer(
    WalletTransferRequest request,
  );
  Future<NetworkResponse<WalletTransferModel>> merchantTransfer(
    MerchantTransferRequest request,
  );
  Future<NetworkResponse<void>> walletTransferComplete(String transactionId);
  Future<NetworkResponse<WithdrawTransferModel>> withdrawTransfer(
    WithdrawTransferRequest request,
  );
  Future<NetworkResponse<void>> withdrawTransferComplete(String transactionId);
  Future<NetworkResponse<WithdrawTransferModel>> withdrawMerchantTransfer(
    MerchantWithdrawTransferRequest request,
  );
  Future<NetworkResponse<void>> merchantWithdrawTransferComplete(
    String transactionId,
  );
}

final class TransfersRemoteDataSourceImpl extends BaseRemoteDataSource
    implements TransfersRemoteDataSource {
  TransfersRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<WalletTransferModel>> walletTransfer(
    WalletTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.walletTransfer,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<WalletTransferResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return WalletTransferResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(WalletTransferModel.fromResponse);
  }

  @override
  Future<NetworkResponse<WalletTransferModel>> merchantTransfer(
    MerchantTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.merchantTransfer,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<WalletTransferResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return WalletTransferResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(WalletTransferModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> walletTransferComplete(
    String transactionId,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.walletTransferComplete(transactionId),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<WithdrawTransferModel>> withdrawTransfer(
    WithdrawTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.withdrawTransfer,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<WithdrawTransferResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return WithdrawTransferResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(WithdrawTransferModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> withdrawTransferComplete(
    String transactionId,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.withdrawTransferComplete(transactionId),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<WithdrawTransferModel>> withdrawMerchantTransfer(
    MerchantWithdrawTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.withDrawMerchantTransfer,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<WithdrawTransferResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return WithdrawTransferResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(WithdrawTransferModel.fromResponse);
  }

  @override
  Future<NetworkResponse<void>> merchantWithdrawTransferComplete(
    String transactionId,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.merchantWithDrawTransferComplete(transactionId),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
