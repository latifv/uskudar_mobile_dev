import 'package:uskudar_mobile/data/dtos/responses/auth_mobile_response.dart';
import 'package:uskudar_mobile/domain/entities/auth_mobile.dart';

final class AuthMobileModel extends AuthMobile {
  const AuthMobileModel({
    required super.activationProcessCode,
    super.token,
    super.customerStatus,
  });

  factory AuthMobileModel.fromResponse(AuthMobileResponse response) {
    return AuthMobileModel(
      activationProcessCode: response.activationProcessCode,
      token: response.token?.toEntity(),
      customerStatus: response.customerStatus,
    );
  }
}
