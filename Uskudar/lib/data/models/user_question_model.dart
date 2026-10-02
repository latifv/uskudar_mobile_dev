import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/user_question_response.dart';
import 'package:payinall/domain/entities/user_question.dart';

final class UserQuestionModel extends UserQuestion {
  const UserQuestionModel({required super.id, required super.name});

  factory UserQuestionModel.fromResponse(UserQuestionResponse response) {
    if (response.id == null || response.name == null) {
      throw const MappingException();
    }

    return UserQuestionModel(id: response.id!, name: response.name!);
  }
}
