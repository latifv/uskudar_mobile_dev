import 'package:json_annotation/json_annotation.dart';

part 'withdraw_transfer_response.g.dart';

@JsonSerializable(createToJson: false)
final class WithdrawTransferResponse {
  const WithdrawTransferResponse({
    this.fullName,
    this.ibanNumber,
    this.amount,
    this.commissionAmount,
    this.commissionFrom,
    this.transactionNumber,
  });

  factory WithdrawTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawTransferResponseFromJson(json);

  final String? fullName;
  final String? ibanNumber;
  final double? amount;
  final double? commissionAmount;
  final String? commissionFrom;
  final String? transactionNumber;
}
