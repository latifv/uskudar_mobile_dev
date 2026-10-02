import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/question_name_params.dart';

part 'question_name_request.g.dart';

@JsonSerializable(createFactory: false)
final class QuestionNameRequest extends QuestionNameParams {
  const QuestionNameRequest({required super.identityNumber});

  factory QuestionNameRequest.fromParams(QuestionNameParams params) {
    return QuestionNameRequest(identityNumber: params.identityNumber);
  }

  Map<String, dynamic> toJson() => _$QuestionNameRequestToJson(this);
}
