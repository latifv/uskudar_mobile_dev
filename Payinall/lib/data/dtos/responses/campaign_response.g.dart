// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignResponse _$CampaignResponseFromJson(Map<String, dynamic> json) =>
    CampaignResponse(
      id: (json['id'] as num?)?.toInt(),
      body: json['body'] as String?,
      campaignMerchants: (json['campaignMerchants'] as List<dynamic>?)
          ?.map(
            (e) => CampaignMerchantResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      campaignType: json['campaignType'] as String?,
      cbType: json['cbType'] as String?,
      discountCode: json['discountCode'] as String?,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      imageUrl: json['imageUrl'] as String?,
      minAmount: (json['minAmount'] as num?)?.toDouble(),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      title: json['title'] as String?,
    );
