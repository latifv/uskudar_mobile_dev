import 'package:json_annotation/json_annotation.dart';

part 'wallet_operator_response.g.dart';

@JsonSerializable(createToJson: false)
class WalletOperatorResponse {
  const WalletOperatorResponse({
    required this.operatorCode,
    required this.operatorName,
    required this.senderCurrencyType,
  });

  factory WalletOperatorResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletOperatorResponseFromJson(json);

  @JsonKey(name: 'operatoR_CODE')
  final String operatorCode;

  @JsonKey(name: 'operatoR_NAME')
  final String operatorName;

  @JsonKey(name: 'sendeR_CURRENCY_TYPE')
  final String senderCurrencyType;
}
