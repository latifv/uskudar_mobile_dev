import 'package:json_annotation/json_annotation.dart';

part 'metropol_user_balance_response.g.dart';

@JsonSerializable(createToJson: false)
final class MetropolUserBalanceResponse {
  const MetropolUserBalanceResponse({this.restoBalance, this.giftBalance});

  factory MetropolUserBalanceResponse.fromJson(Map<String, dynamic> json) =>
      _$MetropolUserBalanceResponseFromJson(json);

  final double? restoBalance;
  final double? giftBalance;
}
