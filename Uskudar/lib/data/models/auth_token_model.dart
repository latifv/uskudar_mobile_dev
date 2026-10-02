import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/auth_token_response.dart';
import 'package:uskudar_mobile/domain/entities/auth_token.dart';

part 'auth_token_model.g.dart';

@HiveType(typeId: 1)
final class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.token,
    required super.expiration,
    required super.endDateMinute,
  });

  factory AuthTokenModel.fromResponse(AuthTokenResponse response) {
    if (response.token == null ||
        response.expiration == null ||
        response.endDateMinute == null) {
      throw const MappingException();
    }

    return AuthTokenModel(
      token: response.token!,
      expiration: response.expiration!,
      endDateMinute: response.endDateMinute!,
    );
  }

  factory AuthTokenModel.fromEntity(AuthToken entity) {
    return AuthTokenModel(
      token: entity.token,
      expiration: entity.expiration,
      endDateMinute: entity.endDateMinute,
    );
  }

  @HiveField(0)
  @override
  String get token => super.token;

  @HiveField(1)
  @override
  DateTime get expiration => super.expiration;

  @HiveField(2)
  @override
  int get endDateMinute => super.endDateMinute;
}
