import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/update_email_send_code_params.dart';

part 'update_email_send_code_request.g.dart';

@JsonSerializable(createFactory: false)
final class UpdateEmailSendCodeRequest extends UpdateEmailSendCodeParams {
  const UpdateEmailSendCodeRequest({
    required super.newEmailAddress,
  });

  factory UpdateEmailSendCodeRequest.fromParams(
    UpdateEmailSendCodeParams params,
  ) {
    return UpdateEmailSendCodeRequest(
      newEmailAddress: params.newEmailAddress,
    );
  }

  Map<String, dynamic> toJson() => _$UpdateEmailSendCodeRequestToJson(this);
}
