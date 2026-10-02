import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/metropol_draw_back_transfer_request.dart';
import 'package:payinall/data/dtos/requests/metropol_gift_transfer_request.dart';
import 'package:payinall/data/dtos/requests/metropol_transaction_list_request.dart';
import 'package:payinall/data/dtos/requests/metropol_transfer_complete_request.dart';
import 'package:payinall/data/dtos/requests/metropol_transfer_request.dart';
import 'package:payinall/data/dtos/requests/point_of_sale_location_filter_request.dart';
import 'package:payinall/data/dtos/requests/point_of_sale_location_request.dart';
import 'package:payinall/data/dtos/responses/metropol_city_response.dart';
import 'package:payinall/data/dtos/responses/metropol_transaction_response.dart';
import 'package:payinall/data/dtos/responses/metropol_transfer_result_response.dart';
import 'package:payinall/data/dtos/responses/metropol_user_balance_response.dart';
import 'package:payinall/data/dtos/responses/metropol_user_detail_response.dart';
import 'package:payinall/data/dtos/responses/point_of_sale_location_response.dart';
import 'package:payinall/data/models/metropol_city_model.dart';
import 'package:payinall/data/models/metropol_transaction_model.dart';
import 'package:payinall/data/models/metropol_transfer_result_model.dart';
import 'package:payinall/data/models/metropol_user_balance_model.dart';
import 'package:payinall/data/models/metropol_user_detail_model.dart';
import 'package:payinall/data/models/point_of_sale_location_model.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

abstract interface class MetropolsRemoteDataSource {
  Future<NetworkResponse<List<MetropolCityModel>>> getCities();
  Future<NetworkResponse<List<PointOfSaleLocationModel>>>
      pointOfSaleLocationList(PointOfSaleLocationRequest request);
  Future<NetworkResponse<List<PointOfSaleLocationModel>>>
      pointOfSaleLocationFilterList(
    PointOfSaleLocationFilterRequest request,
  );
  Future<NetworkResponse<MetropolUserDetailModel>> createUserOrDetail();
  Future<NetworkResponse<MetropolUserBalanceModel>> getUserBalance();
  Future<NetworkResponse<List<MetropolTransactionModel>>> getTransactionList(
    MetropolTransactionListRequest request,
  );
  Future<NetworkResponse<MetropolTransferResultModel>> metropolTransfer(
    MetropolTransferRequest request,
  );
  Future<NetworkResponse<bool>> metropolTransferComplete(
    MetropolTransferCompleteRequest request,
  );
  Future<NetworkResponse<bool>> metropolGiftTransfer(
    MetropolGiftTransferRequest request,
  );
  Future<NetworkResponse<bool>> metropolDrawBackTransfer(
    MetropolDrawBackTransferRequest request,
  );
}

final class MetropolsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements MetropolsRemoteDataSource {
  MetropolsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<List<MetropolCityModel>>> getCities() async {
    final responseJson = await get(endpoint: Endpoints.getCities);
    final response = NetworkResponse.fromJson<List<MetropolCityResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    MetropolCityResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [MetropolCityResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(MetropolCityModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<PointOfSaleLocationModel>>>
      pointOfSaleLocationList(PointOfSaleLocationRequest request) async {
    final responseJson = await post(
      endpoint: Endpoints.pointOfSaleLocationList,
      data: request.toJson(),
    );
    final response =
        NetworkResponse.fromJson<List<PointOfSaleLocationResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => PointOfSaleLocationResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [PointOfSaleLocationResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(PointOfSaleLocationModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<List<PointOfSaleLocationModel>>>
      pointOfSaleLocationFilterList(
    PointOfSaleLocationFilterRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.pointOfSaleLocationFilterList,
      data: request.toJson(),
    );
    final response =
        NetworkResponse.fromJson<List<PointOfSaleLocationResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => PointOfSaleLocationResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [PointOfSaleLocationResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(PointOfSaleLocationModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<MetropolUserDetailModel>> createUserOrDetail() async {
    final responseJson = await post(
      endpoint: Endpoints.createUserOrDetail,
      data: {},
    );
    final response = NetworkResponse.fromJson<MetropolUserDetailResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return MetropolUserDetailResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );
    return response.map(MetropolUserDetailModel.fromResponse);
  }

  @override
  Future<NetworkResponse<MetropolUserBalanceModel>> getUserBalance() async {
    final responseJson = await get(endpoint: Endpoints.getUserBalance);
    final response = NetworkResponse.fromJson<MetropolUserBalanceResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return MetropolUserBalanceResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );
    return response.map(MetropolUserBalanceModel.fromResponse);
  }

  @override
  Future<NetworkResponse<List<MetropolTransactionModel>>> getTransactionList(
    MetropolTransactionListRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getMetropolTransactionList,
      data: request.toJson(),
    );
    final response =
        NetworkResponse.fromJson<List<MetropolTransactionResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => MetropolTransactionResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [MetropolTransactionResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(MetropolTransactionModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<MetropolTransferResultModel>> metropolTransfer(
    MetropolTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.metropolTransfer,
      data: request.toJson(),
    );
    final response =
        NetworkResponse.fromJson<MetropolTransferResultResponse>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return MetropolTransferResultResponse.fromJson(json);
        }
        throw const MappingException();
      },
    );
    return response.map(MetropolTransferResultModel.fromResponse);
  }

  @override
  Future<NetworkResponse<bool>> metropolTransferComplete(
    MetropolTransferCompleteRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.metropolTransferComplete,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResponse<bool>> metropolGiftTransfer(
    MetropolGiftTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.metropolGiftTransfer,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResponse<bool>> metropolDrawBackTransfer(
    MetropolDrawBackTransferRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.metropolDrawBackTransfer,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }
}
