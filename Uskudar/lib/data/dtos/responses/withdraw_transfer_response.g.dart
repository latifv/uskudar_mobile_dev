// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WithdrawTransferResponse _$WithdrawTransferResponseFromJson(
  Map<String, dynamic> json,
) => WithdrawTransferResponse(
  fullName: json['fullName'] as String?,
  ibanNumber: json['ibanNumber'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
  commissionFrom: json['commissionFrom'] as String?,
  transactionNumber: json['transactionNumber'] as String?,
);
