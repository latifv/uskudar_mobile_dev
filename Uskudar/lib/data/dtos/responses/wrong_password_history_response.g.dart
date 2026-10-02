// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrong_password_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WrongPasswordHistoryResponse _$WrongPasswordHistoryResponseFromJson(
  Map<String, dynamic> json,
) => WrongPasswordHistoryResponse(
  createdDate: json['createdDate'] == null
      ? null
      : DateTime.parse(json['createdDate'] as String),
  ipAddress: json['ipAddress'] as String?,
);
