import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/send_new_code_params.dart';

part 'send_new_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class SendNewCodeRequest extends SendNewCodeParams {
  const SendNewCodeRequest({required super.activationProcessCode});

  factory SendNewCodeRequest.fromParams(SendNewCodeParams params) {
    return SendNewCodeRequest(
      activationProcessCode: params.activationProcessCode,
    );
  }

  Map<String, dynamic> toJson() => _$SendNewCodeRequestToJson(this);
}
