// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_merchant_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignMerchantResponse _$CampaignMerchantResponseFromJson(
  Map<String, dynamic> json,
) => CampaignMerchantResponse(
  cbAmount: (json['cbAmount'] as num?)?.toDouble(),
  showMobileApp: json['showMobileApp'] as bool?,
  content: json['content'] as String?,
  imageUrl: json['imageUrl'] as String?,
  merchant: json['merchant'] == null
      ? null
      : MerchantResponse.fromJson(json['merchant'] as Map<String, dynamic>),
  logo: json['logo'] as String?,
);
