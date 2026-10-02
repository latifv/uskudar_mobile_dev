import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/auth_merchant_params.dart';

part 'auth_merchant_request.g.dart';

@JsonSerializable(createFactory: false)
final class AuthMerchantRequest extends AuthMerchantParams {
  const AuthMerchantRequest({
    required super.customerNumber,
    required super.gsmNumber,
    required super.password,
    super.deviceId,
  });

  factory AuthMerchantRequest.fromParams(AuthMerchantParams params) {
    return AuthMerchantRequest(
      customerNumber: params.customerNumber,
      gsmNumber: params.gsmNumber,
      password: params.password,
      deviceId: params.deviceId,
    );
  }

  Map<String, dynamic> toJson() => _$AuthMerchantRequestToJson(this);
}
