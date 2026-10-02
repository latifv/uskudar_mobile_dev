import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/register_params.dart';

part 'register_request.g.dart';

@JsonSerializable(createFactory: false)
final class RegisterRequest extends RegisterParams {
  const RegisterRequest({
    required super.firstName,
    required super.lastName,
    required super.gsmNumber,
    required super.email,
    required super.identityNumber,
    required super.code,
    required super.dateOfBirth,
    required super.password,
    required super.isContractConfirm,
    required super.rePassword,
    required super.userQuestionId,
    required super.secretQuestion,
    required super.seriNo,
  });

  factory RegisterRequest.fromParams(RegisterParams params) {
    return RegisterRequest(
      firstName: params.firstName,
      lastName: params.lastName,
      gsmNumber: params.gsmNumber,
      email: params.email,
      identityNumber: params.identityNumber,
      code: params.code,
      dateOfBirth: params.dateOfBirth,
      password: params.password,
      isContractConfirm: params.isContractConfirm,
      rePassword: params.rePassword,
      userQuestionId: params.userQuestionId,
      secretQuestion: params.secretQuestion,
      seriNo: params.seriNo,
    );
  }

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
