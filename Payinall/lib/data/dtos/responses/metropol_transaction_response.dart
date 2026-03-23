import 'package:json_annotation/json_annotation.dart';

part 'metropol_transaction_response.g.dart';

@JsonSerializable(createToJson: false)
final class MetropolTransactionResponse {
  const MetropolTransactionResponse({
    this.cardNo,
    this.personnelNo,
    this.transactionId,
    this.transactionInfo,
    this.transactionDate,
    this.amount,
    this.walletId,
    this.walletName,
    this.merchantName,
    this.dayCount,
    this.paymentTypeId,
  });

  factory MetropolTransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$MetropolTransactionResponseFromJson(json);

  final String? cardNo;
  final String? personnelNo;
  final String? transactionId;
  final String? transactionInfo;
  final String? transactionDate;
  final String? amount;
  final String? walletId;
  final String? walletName;
  final String? merchantName;
  final int? dayCount;
  final int? paymentTypeId;
}
