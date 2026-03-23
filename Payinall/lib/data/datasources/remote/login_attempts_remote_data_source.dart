import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/responses/last_login_response.dart';
import 'package:payinall/data/models/last_login_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class LoginAttemptsRemoteDataSource {
  Future<NetworkResponse<List<LastLoginModel>>> getLastLogin();
}

final class LoginAttemptsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements LoginAttemptsRemoteDataSource {
  LoginAttemptsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<LastLoginModel>>> getLastLogin() async {
    final responseJson = await get(endpoint: Endpoints.getLastLogin);
    final response = NetworkResponse.fromJson<List<LastLoginResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    LastLoginResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) => responseList.map(LastLoginModel.fromResponse).toList(),
    );
  }
}
