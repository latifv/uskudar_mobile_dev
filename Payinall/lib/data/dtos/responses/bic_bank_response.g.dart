// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bic_bank_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BicBankResponse _$BicBankResponseFromJson(Map<String, dynamic> json) =>
    BicBankResponse(
      branchCode: json['branchCode'] as String?,
      branchName: json['branchName'] as String?,
      code: json['code'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$BicBankResponseToJson(BicBankResponse instance) =>
    <String, dynamic>{
      'branchCode': instance.branchCode,
      'branchName': instance.branchName,
      'code': instance.code,
      'name': instance.name,
    };
