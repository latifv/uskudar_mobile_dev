import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/params/update_secret_question_params.dart';
import 'package:uskudar_mobile/domain/repositories/users_repository.dart';

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
