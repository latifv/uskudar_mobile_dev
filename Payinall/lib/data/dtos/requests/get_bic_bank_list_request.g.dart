// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bic_bank_list_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBicBankListRequest _$GetBicBankListRequestFromJson(
  Map<String, dynamic> json,
) => GetBicBankListRequest(
  countryCode: json['countryCode'] as String,
  corporationCode: json['corporationCode'] as String,
);

Map<String, dynamic> _$GetBicBankListRequestToJson(
  GetBicBankListRequest instance,
) => <String, dynamic>{
  'countryCode': instance.countryCode,
  'corporationCode': instance.corporationCode,
};
