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

  Future<NetworkResponse<PaycoreCardAuthorizationStatus>> getCardAuthorization(
    int cardId,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getPayCoreCardAuthorization(cardId),
    );

    return _mapCardAuthorizationResponse(
      responseJson,
      fallbackMessage: 'Kart e-ticaret yetkileri alınamadı.',
    );
  }

  Future<NetworkResponse<PaycoreVirtualCardSecurity>> getVirtualCardSecurity(
    int cardId,
  ) async {
    final responseJson = await get(
      endpoint: Endpoints.getPayCoreVirtualCardSecurity(cardId),
    );

    if (responseJson is! Map<String, dynamic>) {
      return NetworkResponse.fromJson<PaycoreVirtualCardSecurity>(
        <String, dynamic>{
          'isSuccess': false,
          'message': 'Sanal kart bilgileri alınamadı.',
          'data': null,
        },
      );
    }

    final response = NetworkResponse.fromJson<dynamic>(
      responseJson,
      fromJsonT: (json) => json,
    );

    final securityPayload = _extractFirstPayloadMap(response.data);
    if (securityPayload == null) {
      return NetworkResponse.fromJson<PaycoreVirtualCardSecurity>(
        <String, dynamic>{
          'isSuccess': false,
          'message': response.message ?? 'Sanal kart bilgileri alınamadı.',
          'data': null,
        },
      );
    }

    return NetworkResponse.fromJson<PaycoreVirtualCardSecurity>(
      <String, dynamic>{
        'isSuccess': response.isSuccess,
        'message': response.message,
        'data': securityPayload,
      },
      fromJsonT: (json) => PaycoreVirtualCardSecurity.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  Future<NetworkResponse<PaycoreCardAuthorizationStatus>>
  updateCardEcommerceAuthorization({
    required int cardId,
    required bool isDomesticEcommerceEnabled,
    required bool isInternationalEcommerceEnabled,
  }) async {
    final responseJson = await put(
      endpoint: Endpoints.updatePayCoreCardEcommerceAuthorization,
      data: <String, dynamic>{
        'cardId': cardId,
        'isDomesticEcommerceEnabled': isDomesticEcommerceEnabled,
        'isInternationalEcommerceEnabled': isInternationalEcommerceEnabled,
      },
    );

    return _mapCardAuthorizationResponse(
      responseJson,
      fallbackMessage: 'Kart e-ticaret yetkileri güncellenemedi.',
    );
  }

  NetworkResponse<PaycoreCardAuthorizationStatus> _mapCardAuthorizationResponse(
    dynamic responseJson, {
    required String fallbackMessage,
  }) {
    if (responseJson is! Map<String, dynamic>) {
      return NetworkResponse.fromJson<PaycoreCardAuthorizationStatus>(
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
      return response.map(PaycoreCardAuthorizationStatus.fromJson);
    } on Object {
      return NetworkResponse.fromJson<PaycoreCardAuthorizationStatus>(
        <String, dynamic>{
          'isSuccess': false,
          'message': response.message ?? fallbackMessage,
          'data': null,
        },
      );
    }
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

  Future<NetworkResponse<PaycoreCardTransactionsResponse>> getCardTransactions(
    int cardId, {
    int topRows = 100,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final responseJson = await get(
      endpoint: Endpoints.getPayCoreCardTransactions(cardId),
      queryParameters: <String, dynamic>{
        'topRows': topRows,
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(),
      },
    );

    final response = NetworkResponse.fromJson<dynamic>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) => json,
    );

    final payload = response.data;
    final transactionPayload = payload is Map
        ? Map<String, dynamic>.from(payload)
        : <String, dynamic>{'transactions': payload};

    return NetworkResponse.fromJson<PaycoreCardTransactionsResponse>(
      <String, dynamic>{
        'isSuccess': response.isSuccess,
        'message': response.message,
        'data': transactionPayload,
      },
      fromJsonT: (json) => PaycoreCardTransactionsResponse.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic>? _extractFirstPayloadMap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (payload is Map) {
      return Map<String, dynamic>.from(payload);
    }

    if (payload is List) {
      for (final item in payload) {
        final mapped = _extractFirstPayloadMap(item);
        if (mapped != null) {
          return mapped;
        }
      }
    }

    return null;
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

    if (responseJson is! Map<String, dynamic>) {
      return NetworkResponse.fromJson<PaycorePinStatus>(
        <String, dynamic>{
          'isSuccess': false,
          'message': 'PIN durumu alınamadı.',
          'data': null,
        },
      );
    }

    final rootPayload = _extractPaycorePinStatusPayload(responseJson);
    if (rootPayload != null &&
        responseJson['data'] == null &&
        responseJson['isSuccess'] == null &&
        responseJson['IsSuccess'] == null) {
      return NetworkResponse.fromJson<PaycorePinStatus>(
        <String, dynamic>{
          'isSuccess': true,
          'message': responseJson['message'] ?? responseJson['Message'],
          'data': rootPayload,
        },
        fromJsonT: (json) => PaycorePinStatus.fromJson(
          json as Map<String, dynamic>,
        ),
      );
    }

    final response = NetworkResponse.fromJson<Map<String, dynamic>>(
      responseJson,
      fromJsonT: (json) {
        final payload = _extractPaycorePinStatusPayload(json);
        if (payload != null) {
          return payload;
        }
        throw const MappingException();
      },
    );

    return response.map(PaycorePinStatus.fromJson);
  }

  Map<String, dynamic>? _extractPaycorePinStatusPayload(dynamic json) {
    if (json is Map<String, dynamic>) {
      if (json['data'] is Map<String, dynamic>) {
        return json['data'] as Map<String, dynamic>;
      }

      if (json['result'] is Map<String, dynamic>) {
        return json['result'] as Map<String, dynamic>;
      }

      if (json.containsKey('pinSetFlag') ||
          json.containsKey('PinSetFlag') ||
          json.containsKey('isPinSet') ||
          json.containsKey('IsPinSet') ||
          json.containsKey('lastPinSetDate') ||
          json.containsKey('LastPinSetDate') ||
          json.containsKey('pinSetDate') ||
          json.containsKey('PinSetDate') ||
          json.containsKey('lastPinDate') ||
          json.containsKey('LastPinDate')) {
        return json;
      }
    }

    return null;
  }

  Future<NetworkResponse<void>> setPin(
    int cardId,
    String newPin, {
    String? cardNo,
    String? currentPin,
  }) async {
    final payload = <String, dynamic>{
      'cardId': cardId,
      'newPin': newPin,
    };

    final normalizedCardNo = cardNo?.trim();
    if (normalizedCardNo?.isNotEmpty ?? false) {
      payload['cardNo'] = normalizedCardNo;
    }

    final normalizedCurrentPin = currentPin?.trim();
    if (normalizedCurrentPin?.isNotEmpty ?? false) {
      payload['currentPin'] = normalizedCurrentPin;
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

  Future<NetworkResponse<void>> cancelCard(
    int cardId, {
    String? note,
  }) async {
    final payload = <String, dynamic>{'cardId': cardId};

    final normalizedNote = note?.trim();
    if (normalizedNote?.isNotEmpty ?? false) {
      payload['note'] = normalizedNote;
    }

    final responseJson = await put(
      endpoint: Endpoints.cancelPayCoreCard,
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

  Future<NetworkResponse<void>> addPhysicalCard({
    String? cardNo,
    String? barcodeNo,
    String? gender,
    String? cityName,
    String? townName,
    String? district,
    String? townCode,
    String? cityCode,
    String? postalCode,
    String? address,
  }) async {
    final payload = <String, dynamic>{};

    final normalizedCardNo = cardNo?.trim();
    if (normalizedCardNo?.isNotEmpty ?? false) {
      payload['cardNo'] = normalizedCardNo;
    }

    final normalizedBarcodeNo = barcodeNo?.trim();
    if (normalizedBarcodeNo?.isNotEmpty ?? false) {
      payload['barcodeNo'] = normalizedBarcodeNo;
    }

    final normalizedGender = gender?.trim();
    final normalizedCityName = cityName?.trim();
    final normalizedTownName = townName?.trim();
    final normalizedDistrict = district?.trim();
    final normalizedTownCode = townCode?.trim();
    final normalizedCityCode = cityCode?.trim();
    final normalizedPostalCode = postalCode?.trim();
    final normalizedAddress = address?.trim();

    final hasCustomerCreatePayload = [
      normalizedGender,
      normalizedCityName,
      normalizedTownName,
      normalizedDistrict,
      normalizedTownCode,
      normalizedCityCode,
      normalizedPostalCode,
      normalizedAddress,
    ].any((value) => value?.isNotEmpty ?? false);

    if (hasCustomerCreatePayload) {
      payload['customerCreatePayload'] = <String, dynamic>{
        'gender': normalizedGender,
        'cityName': normalizedCityName,
        'townName': normalizedTownName,
        'district': normalizedDistrict,
        'townCode': _normalizePaycoreTownCode(normalizedTownCode ?? ''),
        'cityCode': _normalizePaycoreCityCode(normalizedCityCode ?? ''),
        'postalCode': normalizedPostalCode,
        'address': normalizedAddress,
      };
    }

    final responseJson = await put(
      endpoint: Endpoints.addPayCorePhysicalCard,
      data: payload,
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<String>> sendAddPhysicalCardOtp({
    String? cardNo,
    String? barcodeNo,
    String? gender,
    String? cityName,
    String? townName,
    String? district,
    String? townCode,
    String? cityCode,
    String? postalCode,
    String? address,
  }) async {
    final payload = <String, dynamic>{};

    final normalizedCardNo = cardNo?.trim();
    if (normalizedCardNo?.isNotEmpty ?? false) {
      payload['cardNo'] = normalizedCardNo;
    }

    final normalizedBarcodeNo = barcodeNo?.trim();
    if (normalizedBarcodeNo?.isNotEmpty ?? false) {
      payload['barcodeNo'] = normalizedBarcodeNo;
    }

    final normalizedGender = gender?.trim();
    final normalizedCityName = cityName?.trim();
    final normalizedTownName = townName?.trim();
    final normalizedDistrict = district?.trim();
    final normalizedTownCode = townCode?.trim();
    final normalizedCityCode = cityCode?.trim();
    final normalizedPostalCode = postalCode?.trim();
    final normalizedAddress = address?.trim();

    final hasCustomerCreatePayload = [
      normalizedGender,
      normalizedCityName,
      normalizedTownName,
      normalizedDistrict,
      normalizedTownCode,
      normalizedCityCode,
      normalizedPostalCode,
      normalizedAddress,
    ].any((value) => value?.isNotEmpty ?? false);

    if (hasCustomerCreatePayload) {
      payload['customerCreatePayload'] = <String, dynamic>{
        'gender': normalizedGender,
        'cityName': normalizedCityName,
        'townName': normalizedTownName,
        'district': normalizedDistrict,
        'townCode': _normalizePaycoreTownCode(normalizedTownCode ?? ''),
        'cityCode': _normalizePaycoreCityCode(normalizedCityCode ?? ''),
        'postalCode': normalizedPostalCode,
        'address': normalizedAddress,
      };
    }

    final responseJson = await post(
      endpoint: Endpoints.sendAddPayCorePhysicalCardOtp,
      data: payload,
    );

    final response = NetworkResponse.fromJson<dynamic>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) => json,
    );

    return response.map((data) => data?.toString() ?? '');
  }

  Future<NetworkResponse<void>> confirmAddPhysicalCardOtp({
    required String processCode,
    required String code,
  }) async {
    final responseJson = await post(
      endpoint: Endpoints.confirmAddPayCorePhysicalCardOtp,
      data: <String, dynamic>{
        'activationProcessCode': processCode,
        'code': code.trim(),
      },
    );

    return NetworkResponse.fromJson<void>(responseJson as Map<String, dynamic>);
  }

  Future<NetworkResponse<PaycoreAtmQrInfo>> getAtmQrInfo(
    String kkfData,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.getPayCoreAtmQrInfo,
      data: <String, dynamic>{
        'kkfData': kkfData.trim(),
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

    return response.map(PaycoreAtmQrInfo.fromJson);
  }

  Future<NetworkResponse<PaycoreAtmQrStartResult>> startAtmQrTransaction({
    required int cardId,
    required String kkfData,
    required double amount,
    required String processingCode,
    required String trxType,
    String channelCode = 'MOB',
  }) async {
    final payload = <String, dynamic>{
      'cardId': cardId,
      'kkfData': kkfData.trim(),
      'qrData': kkfData.trim(),
      'amount': amount,
      'processingCode': processingCode.trim(),
      'trxType': trxType.trim(),
      'channelCode': channelCode,
    };

    final responseJson = await post(
      endpoint: Endpoints.startPayCoreAtmQr,
      data: payload,
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

    return response.map(PaycoreAtmQrStartResult.fromJson);
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
