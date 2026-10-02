import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/user_question.dart';

abstract interface class UserQuestionsRepository {
  Future<Either<Failure, List<UserQuestion>>> getUserQuestions();
}
