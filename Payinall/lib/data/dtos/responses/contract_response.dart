import 'package:json_annotation/json_annotation.dart';

part 'contract_response.g.dart';

@JsonSerializable(createToJson: false)
final class ContractResponse {
  const ContractResponse({this.id, this.code, this.name, this.content});

  factory ContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractResponseFromJson(json);

  final int? id;
  final String? code;
  final String? name;
  final String? content;
}
