import 'package:json_annotation/json_annotation.dart';

part 'gift_check_brand_response.g.dart';

@JsonSerializable(createToJson: false)
final class GiftCheckBrandResponse {
  const GiftCheckBrandResponse({
    this.id,
    this.name,
    this.cashbackRate,
    this.logo,
  });

  factory GiftCheckBrandResponse.fromJson(Map<String, dynamic> json) =>
      _$GiftCheckBrandResponseFromJson(json);

  final String? id;
  final String? name;
  final double? cashbackRate;
  final String? logo;
}
