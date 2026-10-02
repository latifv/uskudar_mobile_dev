import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/data/dtos/responses/auth_token_response.dart';

part 'auth_mobile_response.g.dart';

@JsonSerializable(createToJson: false)
final class AuthMobileResponse {
  const AuthMobileResponse({
    this.activationProcessCode,
    this.token,
    this.customerStatus,
  });

  factory AuthMobileResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthMobileResponseFromJson(json);

  final String? activationProcessCode;
  final AuthTokenResponse? token;
  final int? customerStatus;
}
