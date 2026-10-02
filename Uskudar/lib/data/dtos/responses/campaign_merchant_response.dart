import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/data/dtos/responses/merchant_response.dart';

part 'campaign_merchant_response.g.dart';

@JsonSerializable(createToJson: false)
final class CampaignMerchantResponse {
  const CampaignMerchantResponse({
    this.cbAmount,
    this.showMobileApp,
    this.content,
    this.imageUrl,
    this.merchant,
    this.logo,
  });

  factory CampaignMerchantResponse.fromJson(Map<String, dynamic> json) =>
      _$CampaignMerchantResponseFromJson(json);

  final double? cbAmount;
  final bool? showMobileApp;
  final String? content;
  final String? imageUrl;
  final MerchantResponse? merchant;
  final String? logo;
}
