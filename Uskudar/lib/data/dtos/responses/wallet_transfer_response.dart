import 'package:json_annotation/json_annotation.dart';

part 'wallet_transfer_response.g.dart';

@JsonSerializable(createToJson: false)
final class WalletTransferResponse {
  const WalletTransferResponse({
    this.transactionNumber,
    this.amount,
    this.commissionAmount,
    this.commissionFrom,
    this.buyerFullName,
    this.buyerInfo,
    this.merchantName,
    this.customerNumber,
  });

  factory WalletTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$WalletTransferResponseFromJson(json);

  final String? transactionNumber;
  final double? amount;
  final double? commissionAmount;
  final String? commissionFrom;
  final String? buyerFullName;
  final String? buyerInfo;
  final String? merchantName;
  final String? customerNumber;
}
