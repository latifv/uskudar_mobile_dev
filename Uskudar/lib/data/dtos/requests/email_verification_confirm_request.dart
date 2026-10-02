import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/email_verification_confirm_params.dart';

part 'email_verification_confirm_request.g.dart';

@JsonSerializable(createFactory: false)
final class EmailVerificationConfirmRequest
    extends EmailVerificationConfirmParams {
  const EmailVerificationConfirmRequest({
    required super.code,
    required super.processCode,
  });

  factory EmailVerificationConfirmRequest.fromParams(
    EmailVerificationConfirmParams params,
  ) {
    return EmailVerificationConfirmRequest(
      code: params.code,
      processCode: params.processCode,
    );
  }

  Map<String, dynamic> toJson() =>
      _$EmailVerificationConfirmRequestToJson(this);
}
