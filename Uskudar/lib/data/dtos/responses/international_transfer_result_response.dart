import 'package:json_annotation/json_annotation.dart';

part 'international_transfer_result_response.g.dart';

@JsonSerializable(createToJson: false)
final class InternationalTransferResultResponse {
  const InternationalTransferResultResponse({
    this.toFullName,
    this.toInfo,
    this.amount,
    this.commissionAmount,
    this.commissionFrom,
    this.transactionNumber,
    this.receivedPaymentAmount,
    this.receivedPaymentAmountCurrency,
  });

  factory InternationalTransferResultResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$InternationalTransferResultResponseFromJson(json);

  final String? toFullName;
  final String? toInfo;
  final double? amount;
  final double? commissionAmount;
  final String? commissionFrom;
  final String? transactionNumber;
  final double? receivedPaymentAmount;
  final String? receivedPaymentAmountCurrency;
}
