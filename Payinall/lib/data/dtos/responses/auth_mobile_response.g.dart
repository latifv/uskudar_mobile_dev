// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_mobile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthMobileResponse _$AuthMobileResponseFromJson(Map<String, dynamic> json) =>
    AuthMobileResponse(
      activationProcessCode: json['activationProcessCode'] as String?,
      token: json['token'] == null
          ? null
          : AuthTokenResponse.fromJson(json['token'] as Map<String, dynamic>),
      customerStatus: (json['customerStatus'] as num?)?.toInt(),
    );
