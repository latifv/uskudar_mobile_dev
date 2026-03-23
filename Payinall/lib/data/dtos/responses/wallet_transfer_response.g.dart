// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransferResponse _$WalletTransferResponseFromJson(
  Map<String, dynamic> json,
) => WalletTransferResponse(
  transactionNumber: json['transactionNumber'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
  commissionFrom: json['commissionFrom'] as String?,
  buyerFullName: json['buyerFullName'] as String?,
  buyerInfo: json['buyerInfo'] as String?,
  merchantName: json['merchantName'] as String?,
  customerNumber: json['customerNumber'] as String?,
);
