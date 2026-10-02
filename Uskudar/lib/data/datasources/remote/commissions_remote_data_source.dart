import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/responses/commission_response.dart';
import 'package:uskudar_mobile/data/models/commission_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class CommissionsRemoteDataSource {
  Future<NetworkResponse<List<CommissionModel>>> getActiveList();
  Future<NetworkResponse<List<CommissionModel>>> getMerchantCommissions();
}

final class CommissionsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CommissionsRemoteDataSource {
  CommissionsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<CommissionModel>>> getActiveList() async {
    final responseJson = await get(
      endpoint: Endpoints.commissionsGetActiveList,
    );

    final response = NetworkResponse.fromJson<List<CommissionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    CommissionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) => responseList.map(CommissionModel.fromResponse).toList(),
    );

    return result;
  }

  @override
  Future<NetworkResponse<List<CommissionModel>>>
  getMerchantCommissions() async {
    final responseJson = await get(
      endpoint: Endpoints.getMerchantCommissions,
    );

    final response = NetworkResponse.fromJson<List<CommissionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    CommissionResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );

    final result = response.map(
      (responseList) => responseList.map(CommissionModel.fromResponse).toList(),
    );

    return result;
  }
}
