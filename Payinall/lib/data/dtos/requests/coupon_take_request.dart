import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/coupon_take_params.dart';

part 'coupon_take_request.g.dart';

@JsonSerializable(createFactory: false)
final class CouponTakeRequest extends CouponTakeParams {
  const CouponTakeRequest({
    required super.brandId,
    required super.couponId,
    required super.couponCount,
  });

  factory CouponTakeRequest.fromParams(CouponTakeParams params) {
    return CouponTakeRequest(
      brandId: params.brandId,
      couponId: params.couponId,
      couponCount: params.couponCount,
    );
  }

  Map<String, dynamic> toJson() => _$CouponTakeRequestToJson(this);
}
