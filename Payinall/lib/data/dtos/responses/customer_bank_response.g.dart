// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_bank_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerBankResponse _$CustomerBankResponseFromJson(
  Map<String, dynamic> json,
) => CustomerBankResponse(
  bankId: (json['bankId'] as num?)?.toInt(),
  bankName: json['bankName'] as String?,
  iban: json['iban'] as String?,
  title: json['title'] as String?,
  isOwnerIban: json['isOwnerIban'] as bool?,
);
