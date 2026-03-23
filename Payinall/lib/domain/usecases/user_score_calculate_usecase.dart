import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/params/user_score_calculate_params.dart';
import 'package:payinall/domain/repositories/score_operations_repository.dart';

final class UserScoreCalculateUsecase
    implements BaseUsecase<void, UserScoreCalculateParams> {
  UserScoreCalculateUsecase(this.repository);

  final ScoreOperationsRepository repository;

  @override
  Future<Either<Failure, void>> call(UserScoreCalculateParams params) async {
    final result = await repository.userScoreCalculate(params);
    return result;
  }
}
