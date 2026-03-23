// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corporation_attribute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CorporationAttributeResponse _$CorporationAttributeResponseFromJson(
  Map<String, dynamic> json,
) => CorporationAttributeResponse(
  corporationCode: json['corporationCode'] as String?,
  corporationName: json['corporationName'] as String?,
  currencyCode: json['currencyCode'] as String?,
  requiredAttributeList: (json['requiredAttributeList'] as List<dynamic>?)
      ?.map(
        (e) => RequiredAttributeResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);
