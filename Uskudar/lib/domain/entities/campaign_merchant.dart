import 'package:uskudar_mobile/domain/entities/merchant.dart';

class CampaignMerchant {
  const CampaignMerchant({
    required this.cbAmount,
    required this.showMobileApp,
    required this.content,
    required this.imageUrl,
    required this.merchant,
    required this.logo,
  });

  final double cbAmount;
  final bool showMobileApp;
  final String content;
  final String imageUrl;
  final Merchant merchant;
  final String logo;
}
