import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/change_password_params.dart';

part 'change_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class ChangePasswordRequest extends ChangePasswordParams {
  const ChangePasswordRequest({
    required super.identityNumber,
    required super.oldPassword,
    required super.newPassword,
    required super.retryNewPassword,
  });

  factory ChangePasswordRequest.fromParams(ChangePasswordParams params) {
    return ChangePasswordRequest(
      identityNumber: params.identityNumber,
      oldPassword: params.oldPassword,
      newPassword: params.newPassword,
      retryNewPassword: params.retryNewPassword,
    );
  }

  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}
