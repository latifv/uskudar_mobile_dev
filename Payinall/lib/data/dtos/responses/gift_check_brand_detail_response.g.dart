// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_check_brand_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftCheckBrandDetailResponse _$GiftCheckBrandDetailResponseFromJson(
  Map<String, dynamic> json,
) => GiftCheckBrandDetailResponse(
  id: json['id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  logo: json['logo'] as String?,
  banner: json['banner'] as String?,
  cashbackRate: (json['cashbackRate'] as num?)?.toDouble(),
  kdvRate: (json['kdvRate'] as num?)?.toDouble(),
);
