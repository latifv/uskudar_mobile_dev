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
    return frontForBrand(card.brand);
  }

  static String backForSummary(PaycoreCardSummary card) {
    return backForBrand(card.brand);
  }

  static String frontForBrand(PaycoreCardBrand brand) {
    return switch (brand) {
      PaycoreCardBrand.troy => ImageAssetsConstants.paycoreTroyFront,
      PaycoreCardBrand.mastercard => ImageAssetsConstants.paycoreMasterFront,
      PaycoreCardBrand.visa ||
      PaycoreCardBrand.unknown => ImageAssetsConstants.paycoreTroyFront,
    };
  }

  static String backForBrand(PaycoreCardBrand brand) {
    return switch (brand) {
      PaycoreCardBrand.visa ||
      PaycoreCardBrand.troy ||
      PaycoreCardBrand.mastercard ||
      PaycoreCardBrand.visa ||
      PaycoreCardBrand.unknown => ImageAssetsConstants.paycoreTroyBack,
    };
  }
}
