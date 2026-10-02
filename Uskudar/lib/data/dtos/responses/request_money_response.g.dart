// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_money_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestMoneyResponse _$RequestMoneyResponseFromJson(
  Map<String, dynamic> json,
) => RequestMoneyResponse(
  id: (json['id'] as num?)?.toInt(),
  fromAddress: json['fromAddress'] as String?,
  toAddress: json['toAddress'] as String?,
  toUserName: json['toUserName'] as String?,
  fromUserName: json['fromUserName'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  description: json['description'] as String?,
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
);
