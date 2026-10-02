import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/user_question_response.dart';
import 'package:uskudar_mobile/domain/entities/user_question.dart';

final class UserQuestionModel extends UserQuestion {
  const UserQuestionModel({required super.id, required super.name});

  factory UserQuestionModel.fromResponse(UserQuestionResponse response) {
    if (response.id == null || response.name == null) {
      throw const MappingException();
    }

    return UserQuestionModel(id: response.id!, name: response.name!);
  }
}
