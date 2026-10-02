import 'package:json_annotation/json_annotation.dart';

part 'help_response.g.dart';

@JsonSerializable(createToJson: false)
final class HelpResponse {
  const HelpResponse({this.id, this.title, this.content});

  factory HelpResponse.fromJson(Map<String, dynamic> json) =>
      _$HelpResponseFromJson(json);

  final int? id;
  final String? title;
  final String? content;
}
