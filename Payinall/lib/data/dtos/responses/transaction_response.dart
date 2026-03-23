import 'package:json_annotation/json_annotation.dart';

part 'transaction_response.g.dart';

@JsonSerializable(createToJson: false)
final class TransactionResponse {
  const TransactionResponse({
    this.id,
    this.amount,
    this.commissionAmount,
    this.commissionType,
    this.description,
    this.transferType,
    this.statusName,
    this.fromFullName,
    this.toFullName,
    this.date,
    this.toCustomerNumber,
    this.fromAddress,
    this.transactionTypes,
    this.commissionFromType,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);

  final String? id;
  final double? amount;
  final double? commissionAmount;
  final String? commissionType;
  final String? description;
  final String? transferType;
  final String? statusName;
  final String? fromFullName;
  final String? toFullName;
  final DateTime? date;
  final String? toCustomerNumber;
  final String? fromAddress;
  final int? transactionTypes;
  final int? commissionFromType;
}
