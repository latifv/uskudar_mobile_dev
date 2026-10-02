import 'package:uskudar_mobile/domain/entities/auth_token.dart';

class AuthMobile {
  const AuthMobile({
    this.activationProcessCode,
    this.token,
    this.customerStatus,
  });

  final String? activationProcessCode;
  final AuthToken? token;
  final int? customerStatus;
}
