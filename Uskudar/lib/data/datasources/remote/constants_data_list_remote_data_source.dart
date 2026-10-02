import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/responses/constants_data_response.dart';
import 'package:uskudar_mobile/data/models/constants_data_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class ConstantsDataListRemoteDataSource {
  Future<NetworkResponse<List<ConstantsDataModel>>> getAverageRevenueTypes();
  Future<NetworkResponse<List<ConstantsDataModel>>>
  getMonthlyTransactionCountTypes();
}

final class ConstantsDataListRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ConstantsDataListRemoteDataSource {
  ConstantsDataListRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<ConstantsDataModel>>>
  getAverageRevenueTypes() async {
    try {
      final responseData = await get(endpoint: Endpoints.averageRevenueTypes);

      if (responseData is List) {
        return NetworkResponse<List<ConstantsDataModel>>.fromList(
          responseData,
          mapper: (list) {
            final constantsDataResponses = list
                .map(
                  (item) => ConstantsDataResponse.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();

            return constantsDataResponses
                .map(ConstantsDataModel.fromResponse)
                .toList();
          },
        );
      }

      if (responseData is Map<String, dynamic>) {
        final response = NetworkResponse.fromJson<List<ConstantsDataResponse>>(
          responseData,
          fromJsonT: (json) {
            if (json is List) {
              return json
                  .map(
                    (item) => ConstantsDataResponse.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
            throw const MappingException();
          },
        );

        return response.map(
          (responseList) =>
              responseList.map(ConstantsDataModel.fromResponse).toList(),
        );
      }

      throw const MappingException();
    } catch (e) {
      if (e is MappingException) {
        rethrow;
      }
      throw const ServerException();
    }
  }

  @override
  Future<NetworkResponse<List<ConstantsDataModel>>>
  getMonthlyTransactionCountTypes() async {
    try {
      final responseData = await get(
        endpoint: Endpoints.monthlyTransactionCountTypes,
      );

      if (responseData is List) {
        return NetworkResponse<List<ConstantsDataModel>>.fromList(
          responseData,
          mapper: (list) {
            final constantsDataResponses = list
                .map(
                  (item) => ConstantsDataResponse.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList();

            return constantsDataResponses
                .map(ConstantsDataModel.fromResponse)
                .toList();
          },
        );
      }

      if (responseData is Map<String, dynamic>) {
        final response = NetworkResponse.fromJson<List<ConstantsDataResponse>>(
          responseData,
          fromJsonT: (json) {
            if (json is List) {
              return json
                  .map(
                    (item) => ConstantsDataResponse.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
            throw const MappingException();
          },
        );

        return response.map(
          (responseList) =>
              responseList.map(ConstantsDataModel.fromResponse).toList(),
        );
      }

      throw const MappingException();
    } catch (e) {
      if (e is MappingException) {
        rethrow;
      }
      throw const ServerException();
    }
  }
}
