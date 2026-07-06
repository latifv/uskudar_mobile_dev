import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/core/models/paycore_mobile_models.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

final class PaycoreMobileService extends BaseRemoteDataSource {
  PaycoreMobileService(super.networkClient);

  Future<NetworkResponse<PaycoreCustomerInfo>> getCustomerInfo() async {
    final responseJson = await get(
      endpoint: Endpoints.getMyPayCoreCustomerInfo,
    );

    final response = NetworkResponse.fromJson<Map<String, dynamic>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        throw const MappingException();
      },
    );

    return response.map(PaycoreCustomerInfo.fromJson);
  }

  Future<NetworkResponse<List<PaycoreCardSummary>>> getMyCards() async {
    final responseJson = await get(endpoint: Endpoints.getMyPayCoreCards);

    final response = NetworkResponse.fromJson<List<dynamic>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List<dynamic>) {
          return json;
        }
        return const <dynamic>[];
      },
    );

    return response.map(
      (list) => list
          .whereType<Map<String, dynamic>>()
          .map(PaycoreCardSummary.fromJson)
          .toList(),
    );
  }

  Future<NetworkResponse<void>> createCustomer({
    required String gender,
    required String cityName,
    required String townName,
    required String townCode,
    required String cityCode,
    required String postalCode,
    required String address,
  }) async {
    final responseJson = await post(
      endpoint: Endpoints.createPayCoreCustomer,
      data: <String, dynamic>{
        'gender': gender,
        'cityName': cityName,
        'townName': townName,
        'townCode': townCode,
        'cityCode': cityCode,
        'postalCode': postalCode,
        'address': address,
      },
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<void>> createPrepaidCard({
    required PaycoreCardCreationProfile cardProfile,
    required String cityCode,
    required String cityName,
    required String townCode,
    required String townName,
    required String district,
    required String address1,
    String? address2,
    String? zipCode,
  }) async {
    final responseJson = await post(
      endpoint: Endpoints.createPayCorePrepaidCard,
      data: <String, dynamic>{
        'cardProfile': cardProfile.apiValue,
        'cityCode': cityCode,
        'cityName': cityName,
        'townCode': townCode,
        'townName': townName,
        'district': district,
        'address1': address1,
        'address2': address2,
        'zipCode': zipCode,
      },
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<void>> updateCustomerAddress({
    required String cityName,
    required String townName,
    required String townCode,
    required String cityCode,
    required String postalCode,
    required String address,
  }) async {
    final responseJson = await put(
      endpoint: Endpoints.updatePayCoreCustomerAddress,
      data: <String, dynamic>{
        'cityName': cityName,
        'townName': townName,
        'townCode': townCode,
        'cityCode': cityCode,
        'postalCode': postalCode,
        'address': address,
      },
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<PaycorePinStatus>> getPinStatus(int cardId) async {
    final responseJson = await get(
      endpoint: Endpoints.getPayCorePinStatus(cardId),
    );

    final response = NetworkResponse.fromJson<Map<String, dynamic>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        throw const MappingException();
      },
    );

    return response.map(PaycorePinStatus.fromJson);
  }

  Future<NetworkResponse<void>> setPin(
    int cardId,
    String newPin,
  ) async {
    final responseJson = await put(
      endpoint: Endpoints.setPayCorePin,
      data: <String, dynamic>{'cardId': cardId, 'newPin': newPin},
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<Map<String, dynamic>>> setRandomPin(
    int cardId, {
    bool isSendPinBySms = false,
  }) async {
    final responseJson = await put(
      endpoint: Endpoints.setPayCoreRandomPin,
      data: <String, dynamic>{
        'cardId': cardId,
        'isSendPinBySms': isSendPinBySms,
      },
    );

    return NetworkResponse.fromJson<Map<String, dynamic>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return <String, dynamic>{};
      },
    );
  }

  Future<NetworkResponse<void>> sendPinBySms(int cardId) async {
    final responseJson = await post(
      endpoint: Endpoints.sendPayCorePinBySms,
      data: <String, dynamic>{'cardId': cardId},
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<void>> setPrimaryCard(int cardId) async {
    final responseJson = await put(
      endpoint: Endpoints.setPayCorePrimaryCard,
      data: <String, dynamic>{'cardId': cardId},
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }
}
