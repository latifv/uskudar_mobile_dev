import 'package:json_annotation/json_annotation.dart';

part 'bill_product_type_response.g.dart';

@JsonSerializable(createToJson: false)
final class BillProductTypeResponse {
  const BillProductTypeResponse({
    this.productTypeId,
    this.productTypeName,
  });

  factory BillProductTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$BillProductTypeResponseFromJson(json);

  final String? productTypeId;
  final String? productTypeName;
}
