// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_process_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerProcessResponse _$CustomerProcessResponseFromJson(
  Map<String, dynamic> json,
) => CustomerProcessResponse(
  timeInfo: json['timeInfo'] as String?,
  onlyTransferLimit: (json['onlyTransferLimit'] as num?)?.toInt(),
  processName: json['processName'] as String?,
  remainingNumberOfTransactions: (json['remainingNumberOfTransactions'] as num?)
      ?.toInt(),
  remainingAmountOfMoney: (json['remainingAmountOfMoney'] as num?)?.toInt(),
);
