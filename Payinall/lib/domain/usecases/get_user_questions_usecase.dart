import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/user_question.dart';
import 'package:payinall/domain/repositories/user_questions_repository.dart';

final class GetUserQuestionsUsecase
    implements BaseUsecaseWithoutParams<List<UserQuestion>> {
  GetUserQuestionsUsecase(this.repository);

  final UserQuestionsRepository repository;

  @override
  Future<Either<Failure, List<UserQuestion>>> call() async {
    final result = await repository.getUserQuestions();
    return result;
  }
}
