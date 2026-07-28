import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/core/models/paycore_mobile_models.dart';
import 'package:payinall/data/core/base_remote_data_source.dart';
import 'package:payinall/data/network/config/api_constants.dart';
import 'package:payinall/data/network/config/endpoints.dart';
import 'package:payinall/data/network/models/network_response.dart';

final class PaycoreMobileService extends BaseRemoteDataSource {
  PaycoreMobileService(super.networkClient);

  Future<NetworkResponse<PaycoreCustomerInfo>> getCustomerInfo() async {
    final responseJson = await get(
      endpoint: Endpoints.getMyPayCoreCustomerInfo,
    );
    return _mapCustomerInfoResponse(
      responseJson,
      fallbackMessage: 'Müşteri bilgisi alınamadı.',
    );
  }

  Future<NetworkResponse<PaycoreCustomerInfo>> getCustomerInfoByCustomerNumber(
    String customerNumber,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getPayCoreCustomerInfo(customerNumber),
    );
    return _mapCustomerInfoResponse(
      responseJson,
      fallbackMessage: 'Müşteri bilgisi alınamadı.',
    );
  }

  Future<NetworkResponse<PaycoreCustomerInfo>> getCustomerInfoFromManagement(
    String customerNumber,
  ) async {
    final managementBaseUrl = _resolveManagementBaseUrl(ApiConstants.baseUrl);

    final responseJson = await get(
      endpoint:
          '$managementBaseUrl/PayCoreManagement/get-customer-info/$customerNumber',
    );
    return _mapCustomerInfoResponse(
      responseJson,
      fallbackMessage: 'Management müşteri bilgisi alınamadı.',
    );
  }

  NetworkResponse<PaycoreCustomerInfo> _mapCustomerInfoResponse(
    dynamic responseJson, {
    required String fallbackMessage,
  }) {
    if (responseJson is! Map<String, dynamic>) {
      return NetworkResponse.fromJson<PaycoreCustomerInfo>(
        <String, dynamic>{
          'isSuccess': false,
          'message': fallbackMessage,
          'data': null,
        },
      );
    }

    final response = NetworkResponse.fromJson<Map<String, dynamic>>(
      responseJson,
      fromJsonT: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        throw const MappingException();
      },
    );

    try {
      return response.map(PaycoreCustomerInfo.fromJson);
    } on Object {
      return NetworkResponse.fromJson<PaycoreCustomerInfo>(
        <String, dynamic>{
          'isSuccess': false,
          'message': response.message ?? fallbackMessage,
          'data': null,
        },
      );
    }
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
    required String district,
    required String townCode,
    required String cityCode,
    required String postalCode,
    required String address,
  }) async {
    final normalizedCityCode = _normalizePaycoreCityCode(cityCode);
    final normalizedTownCode = _normalizePaycoreTownCode(townCode);

    final responseJson = await post(
      endpoint: Endpoints.createPayCoreCustomer,
      data: <String, dynamic>{
        'gender': gender,
        'cityName': cityName,
        'townName': townName,
        'district': district,
        'townCode': normalizedTownCode,
        'cityCode': normalizedCityCode,
        'postalCode': postalCode,
        'address': address,
      },
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<PaycoreCreatePrepaidCardResult>> createPrepaidCard({
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
    final normalizedCityCode = _normalizePaycoreCityCode(cityCode);
    final normalizedTownCode = _normalizePaycoreTownCode(townCode);

    final responseJson = await post(
      endpoint: Endpoints.createPayCorePrepaidCard,
      data: <String, dynamic>{
        'cardProfile': cardProfile.apiValue,
        'cityCode': normalizedCityCode,
        'cityName': cityName,
        'townCode': normalizedTownCode,
        'townName': townName,
        'district': district,
        'address1': address1,
        'address2': address2,
        'zipCode': zipCode,
      },
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

    return response.map(PaycoreCreatePrepaidCardResult.fromJson);
  }

  Future<NetworkResponse<void>> updateCustomerAddress({
    required String cityName,
    required String townName,
    required String district,
    required String townCode,
    required String cityCode,
    required String postalCode,
    required String address,
  }) async {
    final normalizedCityCode = _normalizePaycoreCityCode(cityCode);
    final normalizedTownCode = _normalizePaycoreTownCode(townCode);

    final responseJson = await put(
      endpoint: Endpoints.updatePayCoreCustomerAddress,
      data: <String, dynamic>{
        'cityName': cityName,
        'townName': townName,
        'district': district,
        'townCode': normalizedTownCode,
        'cityCode': normalizedCityCode,
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
    String newPin, {
    String? cardNo,
  }) async {
    final payload = <String, dynamic>{
      'cardId': cardId,
      'newPin': newPin,
    };

    final normalizedCardNo = cardNo?.trim();
    if (normalizedCardNo?.isNotEmpty ?? false) {
      payload['cardNo'] = normalizedCardNo;
    }

    final responseJson = await put(
      endpoint: Endpoints.setPayCorePin,
      data: payload,
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<Map<String, dynamic>>> setRandomPin(
    int cardId, {
    String? cardNo,
    bool isSendPinBySms = false,
  }) async {
    final payload = <String, dynamic>{
      'cardId': cardId,
      'isSendPinBySms': isSendPinBySms,
    };

    final normalizedCardNo = cardNo?.trim();
    if (normalizedCardNo?.isNotEmpty ?? false) {
      payload['cardNo'] = normalizedCardNo;
    }

    final responseJson = await put(
      endpoint: Endpoints.setPayCoreRandomPin,
      data: payload,
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

  Future<NetworkResponse<void>> sendPinBySms(
    int cardId, {
    String? cardNo,
  }) async {
    final payload = <String, dynamic>{'cardId': cardId};

    final normalizedCardNo = cardNo?.trim();
    if (normalizedCardNo?.isNotEmpty ?? false) {
      payload['cardNo'] = normalizedCardNo;
    }

    final responseJson = await post(
      endpoint: Endpoints.sendPayCorePinBySms,
      data: payload,
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

  String _resolveManagementBaseUrl(String apiBaseUrl) {
    final normalizedBaseUrl = apiBaseUrl.trim().replaceAll(RegExp(r'/+$'), '');

    if (normalizedBaseUrl.contains('payinallwalletapi.erpapay.com')) {
      return normalizedBaseUrl.replaceFirst(
        'payinallwalletapi.erpapay.com',
        'payinallwalletapp.erpapay.com',
      );
    }

    final parsedUri = Uri.tryParse(normalizedBaseUrl);
    if (parsedUri == null) {
      return normalizedBaseUrl;
    }

    final isLocalHost =
        parsedUri.host == 'localhost' ||
        parsedUri.host == '127.0.0.1' ||
        parsedUri.host == '10.0.2.2';

    if (!isLocalHost) {
      return normalizedBaseUrl;
    }

    final nextPort = switch (parsedUri.port) {
      5093 => 5072,
      7087 => 7052,
      _ => parsedUri.port,
    };

    return parsedUri
        .replace(port: nextPort)
        .toString()
        .replaceAll(
          RegExp(r'/+$'),
          '',
        );
  }

  String _normalizePaycoreCityCode(String value) {
    final digits = value.trim().replaceAll(RegExp(r'\D+'), '');
    if (digits.isEmpty) {
      return '';
    }

    return digits.padLeft(3, '0');
  }

  String _normalizePaycoreTownCode(String value) {
    return value.trim().replaceAll(RegExp(r'\D+'), '');
  }
}
