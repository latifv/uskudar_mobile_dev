// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_receipt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionReceiptResponse _$TransactionReceiptResponseFromJson(
  Map<String, dynamic> json,
) => TransactionReceiptResponse(
  transferOperationTypeName: json['transferOperationTypeName'] as String?,
  orderNumber: json['orderNumber'] as String?,
  receiptNo: json['receiptNo'] as String?,
  fromCustomerFullName: json['fromCustomerFullName'] as String?,
  fromCustomerNumber: json['fromCustomerNumber'] as String?,
  transferStatusTypeName: json['transferStatusTypeName'] as String?,
  commissionFromTypeName: json['commissionFromTypeName'] as String?,
  toCustomerFullName: json['toCustomerFullName'] as String?,
  toCustomerNumber: json['toCustomerNumber'] as String?,
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
  amount: (json['amount'] as num?)?.toDouble(),
  commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
  description: json['description'] as String?,
  institutionAddress: json['institutionAddress'] as String?,
  institutionTaxOffice: json['institutionTaxOffice'] as String?,
  institutionTaxNo: json['institutionTaxNo'] as String?,
  institutionName: json['institutionName'] as String?,
  basisAmount: (json['basisAmount'] as num?)?.toDouble(),
  bsmvAmount: (json['bsmvAmount'] as num?)?.toDouble(),
  bsmvRate: (json['bsmvRate'] as num?)?.toDouble(),
  endingBalance: (json['endingBalance'] as num?)?.toDouble(),
);
