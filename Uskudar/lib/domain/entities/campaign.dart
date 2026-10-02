import 'package:payinall/domain/entities/campaign_merchant.dart';

class Campaign {
  const Campaign({
    required this.id,
    required this.body,
    required this.campaignMerchants,
    required this.campaignType,
    required this.cbType,
    required this.endDate,
    required this.imageUrl,
    required this.minAmount,
    required this.startDate,
    required this.title,
    this.discountCode,
  });

  final int id;
  final String body;
  final List<CampaignMerchant> campaignMerchants;
  final String campaignType;
  final String cbType;
  final String? discountCode;
  final DateTime endDate;
  final String imageUrl;
  final double minAmount;
  final DateTime startDate;
  final String title;
}
