// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_inquiry_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillInquiryResponse _$BillInquiryResponseFromJson(Map<String, dynamic> json) =>
    BillInquiryResponse(
      subscriberName: json['subscriberName'] as String?,
      transactionQueryId: json['transactionQueryId'] as String?,
      invoiceAmount: (json['invoiceAmount'] as num?)?.toDouble(),
      billNo: json['billNo'] as String?,
      billDueDate: json['billDueDate'] as String?,
    );
