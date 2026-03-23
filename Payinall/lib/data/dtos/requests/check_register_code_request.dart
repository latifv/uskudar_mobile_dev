import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/check_register_code_params.dart';

part 'check_register_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class CheckRegisterCodeRequest extends CheckRegisterCodeParams {
  const CheckRegisterCodeRequest({
    required super.activationProcessCode,
    required super.code,
  });

  factory CheckRegisterCodeRequest.fromParams(CheckRegisterCodeParams params) {
    return CheckRegisterCodeRequest(
      activationProcessCode: params.activationProcessCode,
      code: params.code,
    );
  }

  Map<String, dynamic> toJson() => _$CheckRegisterCodeRequestToJson(this);
}
