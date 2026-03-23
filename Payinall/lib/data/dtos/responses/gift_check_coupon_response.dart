import 'package:json_annotation/json_annotation.dart';

part 'gift_check_coupon_response.g.dart';

@JsonSerializable(createToJson: false)
final class GiftCheckCouponResponse {
  const GiftCheckCouponResponse({this.id, this.amount, this.stock});

  factory GiftCheckCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$GiftCheckCouponResponseFromJson(json);

  final String? id;
  final double? amount;
  final int? stock;
}
