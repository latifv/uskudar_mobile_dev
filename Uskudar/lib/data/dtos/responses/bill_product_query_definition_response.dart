import 'package:json_annotation/json_annotation.dart';

part 'bill_product_query_definition_response.g.dart';

@JsonSerializable(createToJson: false)
final class BillProductQueryDefinitionResponse {
  const BillProductQueryDefinitionResponse({
    this.subcriberNumberLabel,
    this.subcriberNumberKeySizeOrder,
    this.mandatoryParams,
  });

  factory BillProductQueryDefinitionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$BillProductQueryDefinitionResponseFromJson(json);

  final String? subcriberNumberLabel;
  final String? subcriberNumberKeySizeOrder;
  final String? mandatoryParams;
}
