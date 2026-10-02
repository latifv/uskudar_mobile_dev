// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_offices_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOfficesRequest _$GetOfficesRequestFromJson(Map<String, dynamic> json) =>
    GetOfficesRequest(
      countryCode: json['countryCode'] as String,
      officeType: json['officeType'] as String,
      corporationCode: json['corporationCode'] as String,
    );

Map<String, dynamic> _$GetOfficesRequestToJson(GetOfficesRequest instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'officeType': instance.officeType,
      'corporationCode': instance.corporationCode,
    };
