// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserInfoResponse _$CurrentUserInfoResponseFromJson(
  Map<String, dynamic> json,
) => CurrentUserInfoResponse(
  customerNumber: json['customerNumber'] as String?,
  lastWrongPasswordDate: json['lastWrongPasswordDate'] == null
      ? null
      : DateTime.parse(json['lastWrongPasswordDate'] as String),
  lastWrongIpAddress: json['lastWrongIpAddress'] as String?,
  gsmNumber: json['gsmNumber'] as String?,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  statusId: (json['statusId'] as num?)?.toInt(),
  customerType: (json['customerType'] as num?)?.toInt(),
  customerTypeName: json['customerTypeName'] as String?,
  notificationTypeId: (json['notificationTypeId'] as num?)?.toInt(),
  email: json['email'] as String?,
  addressType: (json['addressType'] as num?)?.toInt(),
  isExWallet: json['isExWallet'] as bool?,
  image: json['image'] as String?,
  isUserQuestionChange: json['isUserQuestionChange'] as bool?,
  isMailConfirmed: json['isMailConfirmed'] as bool?,
  emailConfirmed: json['emailConfirmed'] as bool?,
);
