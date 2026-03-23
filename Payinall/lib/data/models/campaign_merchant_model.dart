import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/campaign_merchant_response.dart';
import 'package:payinall/data/models/merchant_model.dart';
import 'package:payinall/domain/entities/campaign_merchant.dart';

final class CampaignMerchantModel extends CampaignMerchant {
  const CampaignMerchantModel({
    required super.cbAmount,
    required super.showMobileApp,
    required super.content,
    required super.imageUrl,
    required super.merchant,
    required super.logo,
  });

  factory CampaignMerchantModel.fromResponse(
    CampaignMerchantResponse response,
  ) {
    if (response.cbAmount == null ||
        response.showMobileApp == null ||
        response.content == null ||
        response.imageUrl == null ||
        response.merchant == null ||
        response.logo == null) {
      throw const MappingException();
    }

    return CampaignMerchantModel(
      cbAmount: response.cbAmount!,
      showMobileApp: response.showMobileApp!,
      content: response.content!,
      imageUrl: response.imageUrl!,
      merchant: MerchantModel.fromResponse(response.merchant!),
      logo: response.logo!,
    );
  }
}
