import 'package:json_annotation/json_annotation.dart';

part 'customer_process_response.g.dart';

@JsonSerializable(createToJson: false)
final class CustomerProcessResponse {
  const CustomerProcessResponse({
    this.timeInfo,
    this.onlyTransferLimit,
    this.processName,
    this.remainingNumberOfTransactions,
    this.remainingAmountOfMoney,
  });

  factory CustomerProcessResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerProcessResponseFromJson(json);

  final String? timeInfo;
  final int? onlyTransferLimit;
  final String? processName;
  final int? remainingNumberOfTransactions;
  final int? remainingAmountOfMoney;
}
