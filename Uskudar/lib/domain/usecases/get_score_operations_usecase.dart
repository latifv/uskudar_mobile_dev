import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/score_operation.dart';
import 'package:payinall/domain/params/score_operation_params.dart';
import 'package:payinall/domain/repositories/score_operations_repository.dart';

final class GetScoreOperationsUsecase
    implements BaseUsecase<List<ScoreOperation>, ScoreOperationParams> {
  GetScoreOperationsUsecase(this.repository);

  final ScoreOperationsRepository repository;

  @override
  Future<Either<Failure, List<ScoreOperation>>> call(
    ScoreOperationParams params,
  ) async {
    final result = await repository.getScoreOperations(params);
    return result;
  }
}
