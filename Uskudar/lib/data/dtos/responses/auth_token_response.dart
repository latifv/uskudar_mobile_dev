import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/domain/entities/auth_token.dart';

part 'auth_token_response.g.dart';

@JsonSerializable(createToJson: false)
final class AuthTokenResponse {
  const AuthTokenResponse({this.token, this.expiration, this.endDateMinute});

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(json);

  final String? token;
  final DateTime? expiration;
  final int? endDateMinute;

  AuthToken toEntity() {
    if (token == null || expiration == null || endDateMinute == null) {
      throw const MappingException();
    }
    return AuthToken(
      token: token!,
      expiration: expiration!,
      endDateMinute: endDateMinute!,
    );
  }
}
