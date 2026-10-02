import 'package:json_annotation/json_annotation.dart';

part 'wallet_response.g.dart';

@JsonSerializable(createToJson: false)
final class WalletResponse {
  const WalletResponse({
    this.balance,
    this.availableBalance,
    this.blockBalance,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseFromJson(json);

  final double? balance;
  final double? availableBalance;
  final double? blockBalance;
}
