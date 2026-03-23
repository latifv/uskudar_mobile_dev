import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/score_operation_params.dart';

part 'score_operation_request.g.dart';

@JsonSerializable(createFactory: false)
final class ScoreOperationRequest extends ScoreOperationParams {
  const ScoreOperationRequest({required super.scoreOperationTypes});

  factory ScoreOperationRequest.fromParams(ScoreOperationParams params) {
    return ScoreOperationRequest(
      scoreOperationTypes: params.scoreOperationTypes,
    );
  }

  Map<String, dynamic> toJson() => _$ScoreOperationRequestToJson(this);
}
