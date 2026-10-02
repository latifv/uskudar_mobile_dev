import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/gift_check_coupon_response.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';

final class GiftCheckCouponModel extends GiftCheckCoupon {
  const GiftCheckCouponModel({
    required super.id,
    required super.amount,
    required super.stock,
  });

  factory GiftCheckCouponModel.fromResponse(GiftCheckCouponResponse response) {
    if (response.id == null ||
        response.amount == null ||
        response.stock == null) {
      throw const MappingException();
    }

    return GiftCheckCouponModel(
      id: response.id!,
      amount: response.amount!,
      stock: response.stock!,
    );
  }
}
