// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'password': instance.password,
      'isContractConfirm': instance.isContractConfirm,
      'rePassword': instance.rePassword,
      'gsmNumber': instance.gsmNumber,
      'email': instance.email,
      'code': instance.code,
      'identityNumber': instance.identityNumber,
      'userQuestionId': instance.userQuestionId,
      'secretQuestion': instance.secretQuestion,
      'seriNo': instance.seriNo,
    };
