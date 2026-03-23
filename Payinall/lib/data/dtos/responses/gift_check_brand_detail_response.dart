import 'package:json_annotation/json_annotation.dart';

part 'gift_check_brand_detail_response.g.dart';

@JsonSerializable(createToJson: false)
final class GiftCheckBrandDetailResponse {
  const GiftCheckBrandDetailResponse({
    this.id,
    this.name,
    this.description,
    this.logo,
    this.banner,
    this.cashbackRate,
    this.kdvRate,
  });

  factory GiftCheckBrandDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$GiftCheckBrandDetailResponseFromJson(json);

  final String? id;
  final String? name;
  final String? description;
  final String? logo;
  final String? banner;
  final double? cashbackRate;
  final double? kdvRate;
}
