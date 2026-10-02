import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/check_activation_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/check_merchant_activation_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/send_new_code_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/auth_token_response.dart';
import 'package:uskudar_mobile/data/models/auth_token_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class CustomerActivationsRemoteDataSource {
  Future<NetworkResponse<String>> sendNewCode(SendNewCodeRequest request);

  Future<NetworkResponse<AuthTokenModel>> checkActivationCode(
    CheckActivationCodeRequest request,
  );

  Future<NetworkResponse<AuthTokenModel>> checkMerchantActivationCode(
    CheckMerchantActivationCodeRequest request,
  );
}

final class CustomerActivationsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CustomerActivationsRemoteDataSource {
  CustomerActivationsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<String>> sendNewCode(
    SendNewCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.sendNewCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<AuthTokenModel>> checkActivationCode(
    CheckActivationCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.checkActivationCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AuthTokenResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AuthTokenResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AuthTokenModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AuthTokenModel>> checkMerchantActivationCode(
    CheckMerchantActivationCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.checkMerchantActivationCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AuthTokenResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AuthTokenResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AuthTokenModel.fromResponse);
  }
}
