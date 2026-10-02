import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/responses/frequently_sent_response.dart';
import 'package:payinall/data/models/frequently_sent_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class FrequentlySentsRemoteDataSource {
  Future<NetworkResponse<List<FrequentlySentModel>>> getFrequentlySents();
  Future<NetworkResponse<void>> addFrequentlySent(String customerNumber);
  Future<NetworkResponse<void>> deleteFrequentlySent(int id);
}

final class FrequentlySentsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FrequentlySentsRemoteDataSource {
  FrequentlySentsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<FrequentlySentModel>>>
  getFrequentlySents() async {
    final responseJson = await get(endpoint: Endpoints.getListFrequentlySent);

    final response = NetworkResponse.fromJson<List<FrequentlySentResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => FrequentlySentResponse.fromJson(
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
          responseList.map(FrequentlySentModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<void>> addFrequentlySent(
    String customerNumber,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.addFrequentlySent(customerNumber),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> deleteFrequentlySent(
    int id,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.deleteFrequentlySent(id),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }
}
