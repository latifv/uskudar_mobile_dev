import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/change_phone_params.dart';

part 'change_phone_request.g.dart';

@JsonSerializable(createFactory: false)
final class ChangePhoneRequest extends ChangePhoneParams {
  const ChangePhoneRequest({required super.code, required super.processNumber});

  factory ChangePhoneRequest.fromParams(ChangePhoneParams params) {
    return ChangePhoneRequest(
      code: params.code,
      processNumber: params.processNumber,
    );
  }

  Map<String, dynamic> toJson() => _$ChangePhoneRequestToJson(this);
}
