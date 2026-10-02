import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/data/dtos/responses/campaign_merchant_response.dart';

part 'campaign_response.g.dart';

@JsonSerializable(createToJson: false)
final class CampaignResponse {
  const CampaignResponse({
    this.id,
    this.body,
    this.campaignMerchants,
    this.campaignType,
    this.cbType,
    this.discountCode,
    this.endDate,
    this.imageUrl,
    this.minAmount,
    this.startDate,
    this.title,
  });

  factory CampaignResponse.fromJson(Map<String, dynamic> json) =>
      _$CampaignResponseFromJson(json);

  final int? id;
  final String? body;
  final List<CampaignMerchantResponse>? campaignMerchants;
  final String? campaignType;
  final String? cbType;
  final String? discountCode;
  final DateTime? endDate;
  final String? imageUrl;
  final double? minAmount;
  final DateTime? startDate;
  final String? title;
}
