import 'package:json_annotation/json_annotation.dart';

part 'transaction_receipt_response.g.dart';

@JsonSerializable(createToJson: false)
final class TransactionReceiptResponse {
  const TransactionReceiptResponse({
    this.transferOperationTypeName,
    this.orderNumber,
    this.receiptNo,
    this.fromCustomerFullName,
    this.fromCustomerNumber,
    this.transferStatusTypeName,
    this.commissionFromTypeName,
    this.toCustomerFullName,
    this.toCustomerNumber,
    this.createdDate,
    this.amount,
    this.commissionAmount,
    this.description,
    this.institutionAddress,
    this.institutionTaxOffice,
    this.institutionTaxNo,
    this.institutionName,
    this.basisAmount,
    this.bsmvAmount,
    this.bsmvRate,
    this.endingBalance,
  });

  factory TransactionReceiptResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionReceiptResponseFromJson(json);

  final String? transferOperationTypeName;
  final String? orderNumber;
  final String? receiptNo;
  final String? fromCustomerFullName;
  final String? fromCustomerNumber;
  final String? transferStatusTypeName;
  final String? commissionFromTypeName;
  final String? toCustomerFullName;
  final String? toCustomerNumber;
  final DateTime? createdDate;
  final double? amount;
  final double? commissionAmount;
  final String? description;
  final String? institutionAddress;
  final String? institutionTaxOffice;
  final String? institutionTaxNo;
  final String? institutionName;
  final double? basisAmount;
  final double? bsmvAmount;
  final double? bsmvRate;
  final double? endingBalance;
}
