// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'frequent_iban_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FrequentIbanResponse _$FrequentIbanResponseFromJson(
  Map<String, dynamic> json,
) => FrequentIbanResponse(
  id: json['id'] as String?,
  ibanNo: json['ibanNo'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
);
