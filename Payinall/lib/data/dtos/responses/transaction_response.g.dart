// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      id: json['id'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      commissionAmount: (json['commissionAmount'] as num?)?.toDouble(),
      commissionType: json['commissionType'] as String?,
      description: json['description'] as String?,
      transferType: json['transferType'] as String?,
      statusName: json['statusName'] as String?,
      fromFullName: json['fromFullName'] as String?,
      toFullName: json['toFullName'] as String?,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
      toCustomerNumber: json['toCustomerNumber'] as String?,
      fromAddress: json['fromAddress'] as String?,
      transactionTypes: (json['transactionTypes'] as num?)?.toInt(),
      commissionFromType: (json['commissionFromType'] as num?)?.toInt(),
    );
