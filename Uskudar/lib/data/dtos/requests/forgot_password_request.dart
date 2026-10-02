import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/forgot_password_params.dart';

part 'forgot_password_request.g.dart';

@JsonSerializable(createFactory: false)
final class ForgotPasswordRequest extends ForgotPasswordParams {
  const ForgotPasswordRequest({
    required super.gsmNumber,
    required super.identityNumber,
    required super.answer,
  });

  factory ForgotPasswordRequest.fromParams(ForgotPasswordParams params) {
    return ForgotPasswordRequest(
      gsmNumber: params.gsmNumber,
      identityNumber: params.identityNumber,
      answer: params.answer,
    );
  }

  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);
}
