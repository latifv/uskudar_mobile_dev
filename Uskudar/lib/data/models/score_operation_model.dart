import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/score_operation_response.dart';
import 'package:payinall/domain/entities/score_operation.dart';

final class ScoreOperationModel extends ScoreOperation {
  const ScoreOperationModel({
    required super.id,
    required super.name,
    // required super.score,
    // required super.oldScore,
    // required super.transactionUser,
    // required super.confirmUser,
    // required super.isUpdated,
    // required super.isPep,
    // required super.description,
    // required super.updatedDate,
    // required super.createdDate,
  });

  factory ScoreOperationModel.fromResponse(ScoreOperationResponse response) {
    if (response.id == null || response.name == null
    // || response.score == null
    // || response.oldScore == null ||
    // response.transactionUser == null ||
    // response.confirmUser == null ||
    // response.isUpdated == null ||
    // response.isPep == null ||
    // response.description == null ||
    // response.updatedDate == null ||
    // response.createdDate == null
    ) {
      throw const MappingException();
    }

    return ScoreOperationModel(
      id: response.id!,
      name: response.name!,
      // score: response.score!,
      // oldScore: response.oldScore,
      // transactionUser: response.transactionUser,
      // confirmUser: response.confirmUser,
      // isUpdated: response.isUpdated,
      // isPep: response.isPep,
      // description: response.description,
      // oldScore: response.oldScore,
      // updatedDate: response.updatedDate,
      // createdDate: response.createdDate,
    );
  }
}
