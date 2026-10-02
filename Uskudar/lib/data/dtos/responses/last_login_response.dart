import 'package:json_annotation/json_annotation.dart';

part 'last_login_response.g.dart';

@JsonSerializable(createToJson: false)
final class LastLoginResponse {
  const LastLoginResponse({this.ipAddress, this.date});

  factory LastLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LastLoginResponseFromJson(json);

  final String? ipAddress;
  final String? date;
}
