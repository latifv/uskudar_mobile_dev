// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantResponse _$MerchantResponseFromJson(Map<String, dynamic> json) =>
    MerchantResponse(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: json['_type'] as String?,
      sectorArr: (json['sector_arr'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      logo: json['logo'] as String?,
      sectorArray: (json['sector_array'] as List<dynamic>?)
          ?.map((e) => SectorArrayResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
