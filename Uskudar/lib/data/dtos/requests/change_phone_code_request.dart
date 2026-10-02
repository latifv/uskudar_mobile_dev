import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/change_phone_code_params.dart';

part 'change_phone_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class ChangePhoneCodeRequest extends ChangePhoneCodeParams {
  const ChangePhoneCodeRequest({
    required super.newGsmNumber,
    required super.identityNumber,
    required super.answer,
  });

  factory ChangePhoneCodeRequest.fromParams(ChangePhoneCodeParams params) {
    return ChangePhoneCodeRequest(
      newGsmNumber: params.newGsmNumber,
      identityNumber: params.identityNumber,
      answer: params.answer,
    );
  }

  Map<String, dynamic> toJson() => _$ChangePhoneCodeRequestToJson(this);
}
