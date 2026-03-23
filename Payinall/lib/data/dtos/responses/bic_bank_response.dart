import 'package:json_annotation/json_annotation.dart';

part 'bic_bank_response.g.dart';

@JsonSerializable()
final class BicBankResponse {
  const BicBankResponse({
    this.branchCode,
    this.branchName,
    this.code,
    this.name,
  });

  factory BicBankResponse.fromJson(Map<String, dynamic> json) =>
      _$BicBankResponseFromJson(json);

  final String? branchCode;
  final String? branchName;
  final String? code;
  final String? name;

  Map<String, dynamic> toJson() => _$BicBankResponseToJson(this);
}
