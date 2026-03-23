import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/data/core/data_source_handler.dart';
import 'package:payinall/data/datasources/remote/score_operations_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/score_operation_request.dart';
import 'package:payinall/data/dtos/requests/user_score_calculate_request.dart';
import 'package:payinall/data/models/score_operation_model.dart';
import 'package:payinall/domain/entities/score_operation.dart';
import 'package:payinall/domain/params/score_operation_params.dart';
import 'package:payinall/domain/params/user_score_calculate_params.dart';
import 'package:payinall/domain/repositories/score_operations_repository.dart';

final class ScoreOperationsRepositoryImpl implements ScoreOperationsRepository {
  ScoreOperationsRepositoryImpl({required this.remoteDataSource})
    : _dataSourceHandler = DataSourceHandler();

  final ScoreOperationsRemoteDataSource remoteDataSource;
  final DataSourceHandler _dataSourceHandler;

  @override
  Future<Either<Failure, List<ScoreOperation>>> getScoreOperations(
    ScoreOperationParams params,
  ) async {
    return _dataSourceHandler
        .handle<List<ScoreOperation>, List<ScoreOperationModel>>(
          remoteFunction: () async {
            final request = ScoreOperationRequest.fromParams(params);
            final result = await remoteDataSource.getScoreOperations(request);
            return result;
          },
          onlyData: true,
        );
  }

  @override
  Future<Either<Failure, void>> userScoreCalculate(
    UserScoreCalculateParams params,
  ) async {
    return _dataSourceHandler.handle<void, void>(
      remoteFunction: () async {
        final request = UserScoreCalculateRequest.fromParams(params);
        final result = await remoteDataSource.userScoreCalculate(request);
        return result;
      },
      onlyResponseType: true,
    );
  }
}
