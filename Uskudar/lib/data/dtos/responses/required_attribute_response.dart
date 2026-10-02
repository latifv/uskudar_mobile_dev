import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/data/dtos/responses/attribute_item_response.dart';

part 'required_attribute_response.g.dart';

@JsonSerializable(createToJson: false)
final class RequiredAttributeResponse {
  const RequiredAttributeResponse({
    this.corporationCode,
    this.uniqueName,
    this.displayName,
    this.localizationDisplayName,
    this.attributeItems,
  });

  factory RequiredAttributeResponse.fromJson(Map<String, dynamic> json) =>
      _$RequiredAttributeResponseFromJson(json);

  final String? corporationCode;
  final String? uniqueName;
  final String? displayName;
  final String? localizationDisplayName;
  final List<AttributeItemResponse>? attributeItems;
}
