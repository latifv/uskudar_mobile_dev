import 'package:uskudar_mobile/data/config/environment_config.dart';

final class AppConstants {
  const AppConstants._();
  static String appName = EnvironmentConfig.values.appName;

  static String appVersion = EnvironmentConfig.values.appVersion;
  static String appPackageName = EnvironmentConfig.values.appPackageName;

  static String arkSignerLiveAuth = EnvironmentConfig.values.arkSignerLiveAuth;

  static String googlePlayStoreUrl =
      EnvironmentConfig.values.googlePlayStoreUrl;
  static String appStoreUrl = EnvironmentConfig.values.appStoreUrl;

  static String currencySymbol = EnvironmentConfig.values.currencySymbol;

  static String receiptUrl(String transactionId) =>
      '${EnvironmentConfig.values.receiptUrl}/$transactionId';

  static String qrCodeDeepLinkFormat(String walletAddress, double amount) =>
      '${EnvironmentConfig.values.qrCodeDeepLinkFormat}/$walletAddress/$amount';

  static String customerServicePhoneNumber =
      EnvironmentConfig.values.customerServicePhoneNumber;

  static String customerServiceEmail =
      EnvironmentConfig.values.customerServiceEmail;

  static String socialMediaFacebookUrl =
      EnvironmentConfig.values.socialMediaFacebookUrl;

  static String socialMediaTwitterUrl =
      EnvironmentConfig.values.socialMediaTwitterUrl;

  static String socialMediaInstagramUrl =
      EnvironmentConfig.values.socialMediaInstagramUrl;

  static String socialMediaLinkedinUrl =
      EnvironmentConfig.values.socialMediaLinkedinUrl;
}
