// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficeResponse _$OfficeResponseFromJson(Map<String, dynamic> json) =>
    OfficeResponse(
      officeAddress: json['officeAddress'] as String?,
      officeCityName: json['officeCityName'] as String?,
      officeCode: json['officeCode'] as String?,
      officeCountryName: json['officeCountryName'] as String?,
      officeName: json['officeName'] as String?,
      officePhone: json['officePhone'] as String?,
    );

Map<String, dynamic> _$OfficeResponseToJson(OfficeResponse instance) =>
    <String, dynamic>{
      'officeAddress': instance.officeAddress,
      'officeCityName': instance.officeCityName,
      'officeCode': instance.officeCode,
      'officeCountryName': instance.officeCountryName,
      'officeName': instance.officeName,
      'officePhone': instance.officePhone,
    };
