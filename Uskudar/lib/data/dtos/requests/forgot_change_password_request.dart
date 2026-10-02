import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/forgot_change_password_params.dart';

part 'forgot_change_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class ForgotChangePasswordRequest extends ForgotChangePasswordParams {
  const ForgotChangePasswordRequest({
    required super.password,
    required super.rePassword,
    required super.code,
    required super.address,
  });

  factory ForgotChangePasswordRequest.fromParams(
    ForgotChangePasswordParams params,
  ) {
    return ForgotChangePasswordRequest(
      password: params.password,
      rePassword: params.rePassword,
      code: params.code,
      address: params.address,
    );
  }

  Map<String, dynamic> toJson() => _$ForgotChangePasswordRequestToJson(this);
}
