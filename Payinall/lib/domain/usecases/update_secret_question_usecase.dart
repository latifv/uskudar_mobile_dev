import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/update_secret_question_params.dart';
import 'package:payinall/domain/repositories/users_repository.dart';

final class UpdateSecretQuestionUsecase
    implements BaseUsecase<String, UpdateSecretQuestionParams> {
  UpdateSecretQuestionUsecase(this.repository);

  final UsersRepository repository;

  @override
  Future<Either<Failure, String>> call(
    UpdateSecretQuestionParams params,
  ) async {
    final result = await repository.updateSecretQuestion(params);
    return result;
  }
}
