// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metropol_transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetropolTransactionResponse _$MetropolTransactionResponseFromJson(
  Map<String, dynamic> json,
) => MetropolTransactionResponse(
  cardNo: json['cardNo'] as String?,
  personnelNo: json['personnelNo'] as String?,
  transactionId: json['transactionId'] as String?,
  transactionInfo: json['transactionInfo'] as String?,
  transactionDate: json['transactionDate'] as String?,
  amount: json['amount'] as String?,
  walletId: json['walletId'] as String?,
  walletName: json['walletName'] as String?,
  merchantName: json['merchantName'] as String?,
  dayCount: (json['dayCount'] as num?)?.toInt(),
  paymentTypeId: (json['paymentTypeId'] as num?)?.toInt(),
);
