import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/check_activation_code_params.dart';

part 'check_activation_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class CheckActivationCodeRequest extends CheckActivationCodeParams {
  const CheckActivationCodeRequest({
    required super.activationProcessCode,
    required super.activationCode,
  });

  factory CheckActivationCodeRequest.fromParams(
    CheckActivationCodeParams params,
  ) {
    return CheckActivationCodeRequest(
      activationProcessCode: params.activationProcessCode,
      activationCode: params.activationCode,
    );
  }

  Map<String, dynamic> toJson() => _$CheckActivationCodeRequestToJson(this);
}
