import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/create_fuel_card_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/fuel_card_top_up_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/fuel_card_response.dart';
import 'package:uskudar_mobile/data/models/fuel_card_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class FuelCardsRemoteDataSource {
  Future<NetworkResponse<bool>> createFuelCard(CreateFuelCardRequest request);
  Future<NetworkResponse<List<FuelCardModel>>> getFuelCards();
  Future<NetworkResponse<bool>> deleteFuelCard(int id);
  Future<NetworkResponse<bool>> fuelCardTopUp(FuelCardTopUpRequest request);
  Future<NetworkResponse<double>> getFuelCardBalance(int id);
}

final class FuelCardsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements FuelCardsRemoteDataSource {
  FuelCardsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<bool>> createFuelCard(
    CreateFuelCardRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.createFuelCard,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResponse<List<FuelCardModel>>> getFuelCards() async {
    final responseJson = await get(endpoint: Endpoints.getFuelCards);
    final response = NetworkResponse.fromJson<List<FuelCardResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) =>
                    FuelCardResponse.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
        if (json is Map<String, dynamic>) {
          return [FuelCardResponse.fromJson(json)];
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) => responseList.map(FuelCardModel.fromResponse).toList(),
    );
  }

  @override
  Future<NetworkResponse<bool>> deleteFuelCard(int id) async {
    final responseJson = await delete(
      endpoint: Endpoints.deleteFuelCard(id),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResponse<bool>> fuelCardTopUp(
    FuelCardTopUpRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.fuelCardTopUp,
      data: request.toJson(),
    );
    return NetworkResponse.fromJson<bool>(
      responseJson as Map<String, dynamic>,
    );
  }

  @override
  Future<NetworkResponse<double>> getFuelCardBalance(int id) async {
    final responseJson = await get(
      endpoint: Endpoints.getFuelCardBalance(id),
    );
    return NetworkResponse.fromJson<double>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) => (json as num).toDouble(),
    );
  }
}
