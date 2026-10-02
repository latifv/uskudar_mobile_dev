import 'package:json_annotation/json_annotation.dart';

part 'attribute_item_response.g.dart';

@JsonSerializable(createToJson: false)
final class AttributeItemResponse {
  const AttributeItemResponse({
    this.code,
    this.name,
  });

  factory AttributeItemResponse.fromJson(Map<String, dynamic> json) =>
      _$AttributeItemResponseFromJson(json);

  final String? code;
  final String? name;
}
