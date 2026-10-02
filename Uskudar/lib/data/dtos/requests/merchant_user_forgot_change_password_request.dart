import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/merchant_user_forgot_change_password_params.dart';

part 'merchant_user_forgot_change_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class MerchantUserForgotChangePasswordRequest
    extends MerchantUserForgotChangePasswordParams {
  const MerchantUserForgotChangePasswordRequest({
    required super.gsmNumber,
    required super.customerNumber,
    required super.code,
    required super.password,
    required super.processCode,
  });

  factory MerchantUserForgotChangePasswordRequest.fromParams(
    MerchantUserForgotChangePasswordParams params,
  ) {
    return MerchantUserForgotChangePasswordRequest(
      gsmNumber: params.gsmNumber,
      customerNumber: params.customerNumber,
      code: params.code,
      password: params.password,
      processCode: params.processCode,
    );
  }

  Map<String, dynamic> toJson() =>
      _$MerchantUserForgotChangePasswordRequestToJson(this);
}
