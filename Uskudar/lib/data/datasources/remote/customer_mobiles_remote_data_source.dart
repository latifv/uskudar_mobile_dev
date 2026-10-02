import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/customer_mobiles_request.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class CustomerMobilesRemoteDataSource {
  Future<NetworkResponse<void>> customerMobiles(CustomerMobilesRequest request);
}

final class CustomerMobilesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CustomerMobilesRemoteDataSource {
  CustomerMobilesRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<void>> customerMobiles(
    CustomerMobilesRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.customerMobiles,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
