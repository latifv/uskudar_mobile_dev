import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/user_question.dart';

abstract interface class UserQuestionsRepository {
  Future<Either<Failure, List<UserQuestion>>> getUserQuestions();
}
