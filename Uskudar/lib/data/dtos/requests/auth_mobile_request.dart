import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/auth_mobile_params.dart';

part 'auth_mobile_request.g.dart';

@JsonSerializable(createFactory: false)
final class AuthMobileRequest extends AuthMobileParams {
  const AuthMobileRequest({
    required super.loginInfo,
    required super.password,
    super.deviceId,
  });

  factory AuthMobileRequest.fromParams(AuthMobileParams params) {
    return AuthMobileRequest(
      loginInfo: params.loginInfo,
      password: params.password,
      deviceId: params.deviceId,
    );
  }

  Map<String, dynamic> toJson() => _$AuthMobileRequestToJson(this);
}
