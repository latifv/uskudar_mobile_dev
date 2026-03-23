import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class CustomersRemoteDataSource {
  Future<NetworkResponse<void>> logOut();
}

final class CustomersRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CustomersRemoteDataSource {
  CustomersRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<void>> logOut() async {
    final responseJson = await post(endpoint: Endpoints.logOut);

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
