import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/core/base_remote_data_source.dart';
import 'package:uskudar_mobile/data/dtos/requests/score_operation_request.dart';
import 'package:uskudar_mobile/data/dtos/requests/user_score_calculate_request.dart';
import 'package:uskudar_mobile/data/dtos/responses/score_operation_response.dart';
import 'package:uskudar_mobile/data/models/score_operation_model.dart';
import 'package:uskudar_mobile/data/network/config/endpoints.dart';
import 'package:uskudar_mobile/data/network/models/network_response.dart';

abstract interface class ScoreOperationsRemoteDataSource {
  Future<NetworkResponse<void>> userScoreCalculate(
    UserScoreCalculateRequest request,
  );
  Future<NetworkResponse<List<ScoreOperationModel>>> getScoreOperations(
    ScoreOperationRequest request,
  );
}

final class ScoreOperationsRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ScoreOperationsRemoteDataSource {
  ScoreOperationsRemoteDataSourceImpl(super.networkClient);

  @override
  Future<NetworkResponse<void>> userScoreCalculate(
    UserScoreCalculateRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.userScoreCalculate,
      data: request.toJson(),
    );

    final response = NetworkResponse.fromJson<void>(
      responseJson as Map<String, dynamic>,
    );

    return response;
  }

  @override
  Future<NetworkResponse<List<ScoreOperationModel>>> getScoreOperations(
    ScoreOperationRequest request,
  ) async {
    final responseJson = await post(
      endpoint: Endpoints.scoreOperationList,
      data: request.toJson(),
    );
    final response = NetworkResponse.fromJson<List<ScoreOperationResponse>>(
      responseJson as Map<String, dynamic>,
      fromJsonT: (json) {
        if (json is List) {
          return json
              .map(
                (item) => ScoreOperationResponse.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();
        }
        throw const MappingException();
      },
    );
    return response.map(
      (responseList) =>
          responseList.map(ScoreOperationModel.fromResponse).toList(),
    );
  }
}
