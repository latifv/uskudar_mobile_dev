import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/update_email_confirm_params.dart';

part 'update_email_confirm_request.g.dart';

@JsonSerializable(createFactory: false)
final class UpdateEmailConfirmRequest extends UpdateEmailConfirmParams {
  const UpdateEmailConfirmRequest({
    required super.code,
    required super.processCode,
  });

  factory UpdateEmailConfirmRequest.fromParams(
    UpdateEmailConfirmParams params,
  ) {
    return UpdateEmailConfirmRequest(
      code: params.code,
      processCode: params.processCode,
    );
  }

  Map<String, dynamic> toJson() => _$UpdateEmailConfirmRequestToJson(this);
}
