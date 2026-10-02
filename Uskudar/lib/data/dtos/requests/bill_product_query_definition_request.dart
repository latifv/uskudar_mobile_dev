import 'package:json_annotation/json_annotation.dart';

part 'bill_product_query_definition_request.g.dart';

@JsonSerializable(createFactory: false)
final class BillProductQueryDefinitionRequest {
  const BillProductQueryDefinitionRequest({
    required this.productId,
  });

  final String productId;

  Map<String, dynamic> toJson() =>
      _$BillProductQueryDefinitionRequestToJson(this);
}
