import 'package:json_annotation/json_annotation.dart';

part 'frequent_iban_response.g.dart';

@JsonSerializable(createToJson: false)
final class FrequentIbanResponse {
  const FrequentIbanResponse({
    this.id,
    this.ibanNo,
    this.firstName,
    this.lastName,
    this.createdDate,
  });

  factory FrequentIbanResponse.fromJson(Map<String, dynamic> json) =>
      _$FrequentIbanResponseFromJson(json);

  final String? id;
  final String? ibanNo;
  final String? firstName;
  final String? lastName;
  final DateTime? createdDate;
}
