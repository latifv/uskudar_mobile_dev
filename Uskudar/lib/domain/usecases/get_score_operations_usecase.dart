import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/score_operation.dart';
import 'package:uskudar_mobile/domain/params/score_operation_params.dart';
import 'package:uskudar_mobile/domain/repositories/score_operations_repository.dart';

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
