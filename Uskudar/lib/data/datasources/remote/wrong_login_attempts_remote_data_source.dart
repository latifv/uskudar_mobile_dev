import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/responses/wrong_password_history_response.dart';
import 'package:uskudar_mobile/data/models/wrong_password_history_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class WrongLoginAttemptsRemoteDataSource {
  Future<NetworkResponse<List<WrongPasswordHistoryModel>>>
  getCurrentCustomerWrongPasswordHistories();
}

final class WrongLoginAttemptsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements WrongLoginAttemptsRemoteDataSource {
  WrongLoginAttemptsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<WrongPasswordHistoryModel>>>
  getCurrentCustomerWrongPasswordHistories() async {
    final responseJson = await get(
      endpoint: Endpoints.getCurrentCustomerWrongPasswordHistories,
    );

    final response =
        NetworkResponse.fromJson<List<WrongPasswordHistoryResponse>>(
          responseJson as Map<String, dynamic>,
          fromJsonT: (json) {
            if (json is List) {
              return json
                  .map(
                    (item) => WrongPasswordHistoryResponse.fromJson(
                      item as Map<String, dynamic>,
                    ),
                  )
                  .toList();
            }
            throw const MappingException();
          },
        );

    final result = response.map(
      (responseList) =>
          responseList.map(WrongPasswordHistoryModel.fromResponse).toList(),
    );

    return result;
  }
}
