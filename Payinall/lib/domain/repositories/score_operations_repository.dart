import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/score_operation.dart';
import 'package:payinall/domain/params/score_operation_params.dart';
import 'package:payinall/domain/params/user_score_calculate_params.dart';

abstract interface class ScoreOperationsRepository {
  Future<Either<Failure, void>> userScoreCalculate(
    UserScoreCalculateParams params,
  );
  Future<Either<Failure, List<ScoreOperation>>> getScoreOperations(
    ScoreOperationParams params,
  );
}
