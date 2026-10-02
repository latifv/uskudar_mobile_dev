import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/update_secret_question_params.dart';

part 'update_secret_question_request.g.dart';

@JsonSerializable(createFactory: false)
final class UpdateSecretQuestionRequest {
  const UpdateSecretQuestionRequest({
    required this.userQuestionId,
    required this.secretQuestion,
  });

  factory UpdateSecretQuestionRequest.fromParams(
    UpdateSecretQuestionParams params,
  ) {
    return UpdateSecretQuestionRequest(
      userQuestionId: params.userQuestionId,
      secretQuestion: params.secretQuestion,
    );
  }

  final int userQuestionId;
  final String secretQuestion;

  Map<String, dynamic> toJson() => _$UpdateSecretQuestionRequestToJson(this);
}
