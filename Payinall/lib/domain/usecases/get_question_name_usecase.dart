import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/question_name_params.dart';
import 'package:payinall/domain/repositories/passwords_repository.dart';

final class GetQuestionNameUsecase
    implements BaseUsecase<String, QuestionNameParams> {
  GetQuestionNameUsecase(this.repository);

  final PasswordsRepository repository;

  @override
  Future<Either<Failure, String>> call(QuestionNameParams params) async {
    final result = await repository.getQuestionName(params);
    return result;
  }
}
