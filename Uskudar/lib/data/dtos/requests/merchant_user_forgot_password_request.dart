import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/merchant_user_forgot_password_params.dart';

part 'merchant_user_forgot_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class MerchantUserForgotPasswordRequest
    extends MerchantUserForgotPasswordParams {
  const MerchantUserForgotPasswordRequest({
    required super.gsmNumber,
    required super.customerNumber,
  });

  factory MerchantUserForgotPasswordRequest.fromParams(
    MerchantUserForgotPasswordParams params,
  ) {
    return MerchantUserForgotPasswordRequest(
      gsmNumber: params.gsmNumber,
      customerNumber: params.customerNumber,
    );
  }

  Map<String, dynamic> toJson() =>
      _$MerchantUserForgotPasswordRequestToJson(this);
}
