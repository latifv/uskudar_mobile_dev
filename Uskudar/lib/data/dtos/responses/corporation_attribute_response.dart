import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/data/dtos/responses/required_attribute_response.dart';

part 'corporation_attribute_response.g.dart';

@JsonSerializable(createToJson: false)
final class CorporationAttributeResponse {
  const CorporationAttributeResponse({
    this.corporationCode,
    this.corporationName,
    this.currencyCode,
    this.requiredAttributeList,
  });

  factory CorporationAttributeResponse.fromJson(Map<String, dynamic> json) =>
      _$CorporationAttributeResponseFromJson(json);

  final String? corporationCode;
  final String? corporationName;
  final String? currencyCode;
  final List<RequiredAttributeResponse>? requiredAttributeList;
}
