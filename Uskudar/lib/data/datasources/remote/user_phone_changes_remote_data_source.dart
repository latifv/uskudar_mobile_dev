import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/change_phone_code_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/change_phone_request.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class UserPhoneChangesRemoteDataSource {
  Future<NetworkResponse<String>> changePhoneCode(
    ChangePhoneCodeRequest request,
  );
  Future<NetworkResponse<void>> changePhone(ChangePhoneRequest request);
}

final class UserPhoneChangesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements UserPhoneChangesRemoteDataSource {
  UserPhoneChangesRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<String>> changePhoneCode(
    ChangePhoneCodeRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.changePhoneCode,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<String>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> changePhone(ChangePhoneRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.changePhone,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
