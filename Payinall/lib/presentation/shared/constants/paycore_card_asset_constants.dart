import 'package:payinall/core/models/paycore_mobile_models.dart';
import 'package:payinall/presentation/shared/constants/image_asset_constants.dart';

final class PaycoreCardAssetConstants {
  const PaycoreCardAssetConstants._();

  static String frontForProfile(PaycoreCardCreationProfile profile) {
    return switch (profile) {
      PaycoreCardCreationProfile.troyVirtual ||
      PaycoreCardCreationProfile.troyPhysical =>
        ImageAssetsConstants.paycoreTroyFront,
      PaycoreCardCreationProfile.masterVirtual ||
      PaycoreCardCreationProfile.masterPhysical =>
        ImageAssetsConstants.paycoreMasterFront,
    };
  }

  static String backForProfile(PaycoreCardCreationProfile profile) {
    return switch (profile) {
      PaycoreCardCreationProfile.troyVirtual ||
      PaycoreCardCreationProfile.troyPhysical =>
        ImageAssetsConstants.paycoreTroyBack,
      PaycoreCardCreationProfile.masterVirtual ||
      PaycoreCardCreationProfile.masterPhysical =>
        ImageAssetsConstants.paycoreMasterBack,
    };
  }

  static String frontForSummary(PaycoreCardSummary card) {
    return _isMasterCard(card)
        ? ImageAssetsConstants.paycoreMasterFront
        : ImageAssetsConstants.paycoreTroyFront;
  }

  static String backForSummary(PaycoreCardSummary card) {
    return _isMasterCard(card)
        ? ImageAssetsConstants.paycoreMasterBack
        : ImageAssetsConstants.paycoreTroyBack;
  }

  static bool _isMasterCard(PaycoreCardSummary card) {
    final productCode = card.productCode?.trim().toUpperCase() ?? '';
    final profileLabel = card.profileLabel.toUpperCase();

    return productCode.startsWith('MC') || profileLabel.contains('MASTER');
  }
}
