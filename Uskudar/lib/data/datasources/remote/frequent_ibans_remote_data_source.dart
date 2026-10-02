import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/add_frequent_iban_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/frequent_iban_response.dart';
import 'package:uskudar_mobile/data/models/frequent_iban_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class FrequentIbansRemoteDataSource {
  Future<NetworkResponse<List<FrequentIbanModel>>> getFrequentIbans();
  Future<NetworkResponse<void>> addFrequentIban(AddFrequentIbanRequest request);
  Future<NetworkResponse<void>> deleteFrequentIban(String id);
}

final class FrequentIbansRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FrequentIbansRemoteDataSource {
  FrequentIbansRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<FrequentIbanModel>>> getFrequentIbans() async {
    final responseJson = await get(endpoint: Endpoints.frequentIbans);

    final response = NetworkResponse.fromJson<List<FrequentIbanResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => FrequentIbanResponse.fromJson(
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
          responseList.map(FrequentIbanModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<void>> addFrequentIban(
    AddFrequentIbanRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.frequentIbans,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> deleteFrequentIban(String id) async {
    final responseJson = await delete(
      endpoint: Endpoints.deleteFrequentIban(id),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
