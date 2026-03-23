import 'package:json_annotation/json_annotation.dart';

part 'wrong_password_history_response.g.dart';

@JsonSerializable(createToJson: false)
final class WrongPasswordHistoryResponse {
  const WrongPasswordHistoryResponse({
    this.createdDate,
    this.ipAddress,
  });

  factory WrongPasswordHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$WrongPasswordHistoryResponseFromJson(json);

  final DateTime? createdDate;
  final String? ipAddress;
}
