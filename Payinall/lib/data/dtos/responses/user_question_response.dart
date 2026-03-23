import 'package:json_annotation/json_annotation.dart';

part 'user_question_response.g.dart';

@JsonSerializable(createToJson: false)
final class UserQuestionResponse {
  const UserQuestionResponse({this.id, this.name});

  factory UserQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$UserQuestionResponseFromJson(json);

  final int? id;
  final String? name;
}
