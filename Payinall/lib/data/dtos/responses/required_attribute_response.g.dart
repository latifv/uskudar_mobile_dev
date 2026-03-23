// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'required_attribute_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequiredAttributeResponse _$RequiredAttributeResponseFromJson(
  Map<String, dynamic> json,
) => RequiredAttributeResponse(
  corporationCode: json['corporationCode'] as String?,
  uniqueName: json['uniqueName'] as String?,
  displayName: json['displayName'] as String?,
  localizationDisplayName: json['localizationDisplayName'] as String?,
  attributeItems: (json['attributeItems'] as List<dynamic>?)
      ?.map((e) => AttributeItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);
