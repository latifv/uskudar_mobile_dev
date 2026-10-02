import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/check_merchant_activation_code_params.dart';

part 'check_merchant_activation_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class CheckMerchantActivationCodeRequest
    extends CheckMerchantActivationCodeParams {
  const CheckMerchantActivationCodeRequest({
    required super.activationProcessCode,
    required super.activationCode,
  });

  factory CheckMerchantActivationCodeRequest.fromParams(
    CheckMerchantActivationCodeParams params,
  ) {
    return CheckMerchantActivationCodeRequest(
      activationProcessCode: params.activationProcessCode,
      activationCode: params.activationCode,
    );
  }

  Map<String, dynamic> toJson() =>
      _$CheckMerchantActivationCodeRequestToJson(this);
}
