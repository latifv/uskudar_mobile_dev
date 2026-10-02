import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/responses/help_response.dart';
import 'package:uskudar_mobile/data/models/help_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class HelpsRemoteDataSource {
  Future<NetworkResponse<List<HelpModel>>> getHelps();
}

final class HelpsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements HelpsRemoteDataSource {
  HelpsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<HelpModel>>> getHelps() async {
    final responseJson = await get(endpoint: Endpoints.helps);
    final response = NetworkResponse.fromJson<List<HelpResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => HelpResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [HelpResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) => responseList.map(HelpModel.fromResponse).toList(),
    );
  }
}
