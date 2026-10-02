// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metropol_transfer_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetropolTransferResultResponse _$MetropolTransferResultResponseFromJson(
  Map<String, dynamic> json,
) => MetropolTransferResultResponse(
  merchantName: json['MerchantName'] as String?,
  cityName: json['CityName'] as String?,
  districtName: json['DistrictName'] as String?,
  requestAmount: json['RequestAmount'] as String?,
  transactionId: (json['TransactionId'] as num?)?.toInt(),
  productName: json['ProductName'] as String?,
  kdv: json['Kdv'] as String?,
  saleRefCode: json['SaleRefCode'] as String?,
  sessionExpireDate: json['SessionExpireDate'] as String?,
);
