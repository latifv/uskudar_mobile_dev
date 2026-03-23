import 'package:json_annotation/json_annotation.dart';

part 'metropol_user_detail_response.g.dart';

@JsonSerializable(createToJson: false)
final class MetropolUserDetailResponse {
  const MetropolUserDetailResponse({
    this.userNo,
    this.cardNo,
    this.userAccountToken,
  });

  factory MetropolUserDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$MetropolUserDetailResponseFromJson(json);

  final int? userNo;
  final String? cardNo;
  final String? userAccountToken;
}
