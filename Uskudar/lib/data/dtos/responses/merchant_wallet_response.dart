import 'package:json_annotation/json_annotation.dart';

part 'merchant_wallet_response.g.dart';

@JsonSerializable(createToJson: false)
final class MerchantWalletResponse {
  const MerchantWalletResponse({
    required this.id,
    required this.customerNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.merchantId,
    required this.merchantCompanyName,
    required this.balance,
    required this.blockBalance,
    required this.availableBalance,
    required this.isWalletLocked,
  });

  factory MerchantWalletResponse.fromJson(Map<String, dynamic> json) =>
      _$MerchantWalletResponseFromJson(json);

  final int? id;
  final String? customerNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final int? merchantId;
  final String? merchantCompanyName;
  final num? balance;
  final num? blockBalance;
  final num? availableBalance;
  final bool? isWalletLocked;
}
