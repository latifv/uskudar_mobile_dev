import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/request_moneys_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/request_money_response.dart';
import 'package:uskudar_mobile/data/models/request_money_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class RequestMoneysRemoteDataSource {
  Future<NetworkResponse<void>> requestMoney(RequestMoneyRequest request);
  Future<NetworkResponse<void>> deleteRequestMoney(int id);
  Future<NetworkResponse<List<RequestMoneyModel>>> getSenderRequestMoneys();
  Future<NetworkResponse<List<RequestMoneyModel>>> getBuyerRequestMoneys();
}

final class RequestMoneysRemoteDataSourceImpl extends BaseRemoteDataSource
    implements RequestMoneysRemoteDataSource {
  RequestMoneysRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<void>> requestMoney(
    RequestMoneyRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.requestMoney,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<void>> deleteRequestMoney(int id) async {
    final responseJson = await delete(
      endpoint: Endpoints.deleteRequestMoney(id),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<List<RequestMoneyModel>>>
  getSenderRequestMoneys() async {
    final responseJson = await get(endpoint: Endpoints.senderRequestMoneyList);
    final response = NetworkResponse.fromJson<List<RequestMoneyResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    RequestMoneyResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(RequestMoneyModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<RequestMoneyModel>>>
  getBuyerRequestMoneys() async {
    final responseJson = await get(endpoint: Endpoints.buyerRequestMoneyList);
    final response = NetworkResponse.fromJson<List<RequestMoneyResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    RequestMoneyResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(RequestMoneyModel.fromResponse).toList(),
    );
  }
}
