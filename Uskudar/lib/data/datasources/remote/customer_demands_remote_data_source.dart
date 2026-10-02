import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_customer_demand_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/customer_demand_subject_response.dart';
import 'package:uskudar_mobile/data/models/customer_demand_subject_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class CustomerDemandsRemoteDataSource {
  Future<NetworkResponse<List<CustomerDemandSubjectModel>>> getSubjectTypes();
  Future<NetworkResponse<void>> createDemand(
    CreateCustomerDemandRequest request,
  );
}

final class CustomerDemandsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CustomerDemandsRemoteDataSource {
  CustomerDemandsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<CustomerDemandSubjectModel>>>
  getSubjectTypes() async {
    final responseJson = await get(
      endpoint: Endpoints.customerDemandSubjectTypes,
    );
    final response = NetworkResponse.fromList(
      responseJson as List<dynamic>,
      mapper: (list) => list
          .map(
            (item) => CustomerDemandSubjectResponse.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    return response.map(
      (list) => list.map(CustomerDemandSubjectModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<void>> createDemand(
    CreateCustomerDemandRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.createCustomerDemand,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );
  }
}
