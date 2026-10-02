import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/user_score_calculate_params.dart';

part 'user_score_calculate_request.g.dart';

@JsonSerializable(createFactory: false)
final class UserScoreCalculateRequest extends UserScoreCalculateParams {
  const UserScoreCalculateRequest({
    required super.businessTypeId,
    required super.jobId,
    required super.presenceSourceId,
    required super.monthlyTransactionCountTypeId,
    required super.averageRevenueTypeId,
  });

  factory UserScoreCalculateRequest.fromParams(
    UserScoreCalculateParams params,
  ) {
    return UserScoreCalculateRequest(
      businessTypeId: params.businessTypeId,
      jobId: params.jobId,
      presenceSourceId: params.presenceSourceId,
      monthlyTransactionCountTypeId: params.monthlyTransactionCountTypeId,
      averageRevenueTypeId: params.averageRevenueTypeId,
    );
  }

  Map<String, dynamic> toJson() => _$UserScoreCalculateRequestToJson(this);
}
