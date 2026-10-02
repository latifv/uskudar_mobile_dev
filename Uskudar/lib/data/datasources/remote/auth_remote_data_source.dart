import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/auth_merchant_request.dart';
import 'package:payinall/data/dtos/requests/auth_mobile_request.dart';
import 'package:payinall/data/dtos/responses/auth_mobile_response.dart';
import 'package:payinall/data/models/auth_mobile_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<NetworkResponse<AuthMobileModel>> authMobile(
    AuthMobileRequest request,
  );
  Future<NetworkResponse<AuthMobileModel>> authMerchant(
    AuthMerchantRequest request,
  );
}

final class AuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<AuthMobileModel>> authMobile(
    AuthMobileRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.authMobile,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AuthMobileResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AuthMobileResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AuthMobileModel.fromResponse);
  }

  @override
  Future<NetworkResponse<AuthMobileModel>> authMerchant(
    AuthMerchantRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.authMerchant,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<AuthMobileResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return AuthMobileResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );

    return response.map(AuthMobileModel.fromResponse);
  }
}
