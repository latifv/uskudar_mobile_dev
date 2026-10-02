import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/campaign_response.dart';
import 'package:payinall/data/models/campaign_merchant_model.dart';
import 'package:payinall/domain/entities/campaign.dart';

final class CampaignModel extends Campaign {
  const CampaignModel({
    required super.id,
    required super.body,
    required super.campaignMerchants,
    required super.campaignType,
    required super.cbType,
    required super.endDate,
    required super.imageUrl,
    required super.minAmount,
    required super.startDate,
    required super.title,
    super.discountCode,
  });

  factory CampaignModel.fromResponse(CampaignResponse response) {
    if (response.id == null ||
        response.body == null ||
        response.campaignMerchants == null ||
        response.campaignType == null ||
        response.cbType == null ||
        response.endDate == null ||
        response.imageUrl == null ||
        response.minAmount == null ||
        response.startDate == null ||
        response.title == null) {
      throw const MappingException();
    }

    return CampaignModel(
      id: response.id!,
      body: response.body!,
      campaignMerchants: response.campaignMerchants!
          .map(CampaignMerchantModel.fromResponse)
          .toList(),
      campaignType: response.campaignType!,
      cbType: response.cbType!,
      discountCode: response.discountCode,
      endDate: response.endDate!,
      imageUrl: response.imageUrl!,
      minAmount: response.minAmount!,
      startDate: response.startDate!,
      title: response.title!,
    );
  }
}
