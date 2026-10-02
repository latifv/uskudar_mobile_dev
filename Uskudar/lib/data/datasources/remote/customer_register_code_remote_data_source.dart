import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/check_register_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_register_code_request.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class CustomerRegisterCodeRemoteDataSource {
  Future<NetworkResponse<String>> createRegisterCode(
    CreateRegisterCodeRequest request,
  );

  Future<NetworkResponse<void>> checkRegisterCode(
    CheckRegisterCodeRequest request,
  );
}

final class CustomerRegisterCodeRemoteDataSourceImpl
    extends BaseRemoteDataSource
    implements CustomerRegisterCodeRemoteDataSource {
  CustomerRegisterCodeRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<String>> createRegisterCode(
    CreateRegisterCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.createRegisterCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> checkRegisterCode(
    CheckRegisterCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.checkRegisterCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
