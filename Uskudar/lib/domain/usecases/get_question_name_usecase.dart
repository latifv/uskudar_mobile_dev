import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/question_name_params.dart';
import 'package:uskudar_mobile/domain/repositories/passwords_repository.dart';

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
