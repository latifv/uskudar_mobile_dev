import 'package:json_annotation/json_annotation.dart';

part 'frequently_sent_response.g.dart';

@JsonSerializable(createToJson: false)
final class FrequentlySentResponse {
  const FrequentlySentResponse({
    this.id,
    this.customerNumber,
    this.fullName,
  });

  factory FrequentlySentResponse.fromJson(Map<String, dynamic> json) =>
      _$FrequentlySentResponseFromJson(json);

  final int? id;
  final String? customerNumber;
  final String? fullName;
}
