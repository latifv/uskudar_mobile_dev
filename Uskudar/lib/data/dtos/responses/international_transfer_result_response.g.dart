// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'international_transfer_result_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InternationalTransferResultResponse
_$InternationalTransferResultResponseFromJson(Map<String, dynamic> json) =>
    InternationalTransferResultResponse(
      toFullName: json['toFullName'] as String?,
      toInfo: json['toInfo'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
      commissionFrom: json['commissionFrom'] as String?,
      transactionNumber: json['transactionNumber'] as String?,
      receivedPaymentAmount: (json['receivedPaymentAmount'] as num?)
          ?.toDouble(),
      receivedPaymentAmountCurrency:
          json['receivedPaymentAmountCurrency'] as String?,
    );
