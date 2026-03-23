import 'package:json_annotation/json_annotation.dart';

part 'score_operation_response.g.dart';

@JsonSerializable(createToJson: false)
final class ScoreOperationResponse {
  const ScoreOperationResponse({
    this.id,
    this.name,
    // this.score,
    // this.oldScore,
    // this.transactionUser,
    // this.confirmUser,
    // this.isUpdated,
    // this.isPep,
    // this.description,
    // this.updatedDate,
    // this.createdDate,
  });

  factory ScoreOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$ScoreOperationResponseFromJson(json);

  final int? id;
  final String? name;
  // final int? score;
  // final int? oldScore;
  // final dynamic transactionUser;
  // final dynamic confirmUser;
  // final bool? isUpdated;
  // final bool? isPep;
  // final String? description;
  // final DateTime? updatedDate;
  // final DateTime? createdDate;
}
