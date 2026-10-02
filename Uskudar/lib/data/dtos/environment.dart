import 'package:json_annotation/json_annotation.dart';

part 'environment.g.dart';

@JsonSerializable(createToJson: false)
final class Environment {
  const Environment({
    required this.appName,
    required this.apiUrl,
    required this.signalrUrl,
    required this.receiptUrl,
    required this.appVersion,
    required this.appPackageName,
    required this.arkSignerLiveAuth,
    required this.googlePlayStoreUrl,
    required this.appStoreUrl,
    required this.currencySymbol,
    required this.qrCodeDeepLinkFormat,
    required this.customerServicePhoneNumber,
    required this.customerServiceEmail,
    required this.socialMediaFacebookUrl,
    required this.socialMediaTwitterUrl,
    required this.socialMediaInstagramUrl,
    required this.socialMediaLinkedinUrl,
  });

  factory Environment.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentFromJson(json);

  @JsonKey(name: 'APP_NAME')
  final String appName;

  @JsonKey(name: 'API_URL')
  final String apiUrl;

  @JsonKey(name: 'SIGNALR_URL')
  final String signalrUrl;

  @JsonKey(name: 'RECEIPT_URL')
  final String receiptUrl;

  @JsonKey(name: 'APP_VERSION')
  final String appVersion;

  @JsonKey(name: 'APP_PACKAGE_NAME')
  final String appPackageName;

  @JsonKey(name: 'ARK_SIGNER_LIVE_AUTH')
  final String arkSignerLiveAuth;

  @JsonKey(name: 'GOOGLE_PLAY_STORE_URL')
  final String googlePlayStoreUrl;

  @JsonKey(name: 'APP_STORE_URL')
  final String appStoreUrl;

  @JsonKey(name: 'CURRENCY_SYMBOL')
  final String currencySymbol;

  @JsonKey(name: 'QR_CODE_DEEP_LINK_FORMAT')
  final String qrCodeDeepLinkFormat;

  @JsonKey(name: 'CUSTOMER_SERVICE_PHONE_NUMBER')
  final String customerServicePhoneNumber;

  @JsonKey(name: 'CUSTOMER_SERVICE_EMAIL')
  final String customerServiceEmail;

  @JsonKey(name: 'SOCIAL_MEDIA_FACEBOOK_URL')
  final String socialMediaFacebookUrl;

  @JsonKey(name: 'SOCIAL_MEDIA_TWITTER_URL')
  final String socialMediaTwitterUrl;

  @JsonKey(name: 'SOCIAL_MEDIA_INSTAGRAM_URL')
  final String socialMediaInstagramUrl;

  @JsonKey(name: 'SOCIAL_MEDIA_LINKEDIN_URL')
  final String socialMediaLinkedinUrl;
}
