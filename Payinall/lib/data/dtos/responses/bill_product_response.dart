import 'package:json_annotation/json_annotation.dart';

part 'bill_product_response.g.dart';

@JsonSerializable(createToJson: false)
final class BillProductResponse {
  const BillProductResponse({
    this.productId,
    this.productName,
  });

  factory BillProductResponse.fromJson(Map<String, dynamic> json) =>
      _$BillProductResponseFromJson(json);

  final String? productId;
  final String? productName;
}
