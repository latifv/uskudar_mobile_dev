// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bank_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppBankResponse _$AppBankResponseFromJson(Map<String, dynamic> json) =>
    AppBankResponse(
      id: (json['id'] as num?)?.toInt(),
      bankId: (json['bankId'] as num?)?.toInt(),
      bankName: json['bankName'] as String?,
      iban: json['iban'] as String?,
      order: (json['order'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool?,
    );
