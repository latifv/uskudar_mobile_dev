part of 'gift_check_brand_detail_bloc.dart';

sealed class GiftCheckBrandDetailEvent {
  const GiftCheckBrandDetailEvent();
}

final class GiftCheckBrandDetailLoad extends GiftCheckBrandDetailEvent {
  const GiftCheckBrandDetailLoad({required this.brandId});
  final String brandId;
}

final class GiftCheckBrandDetailSelectCoupon extends GiftCheckBrandDetailEvent {
  const GiftCheckBrandDetailSelectCoupon({required this.couponId});

  final String couponId;
}

final class GiftCheckBrandDetailTakeCoupon extends GiftCheckBrandDetailEvent {
  const GiftCheckBrandDetailTakeCoupon({
    required this.brandId,
    required this.couponId,
    required this.couponCount,
  });
  final String brandId;
  final String couponId;
  final int couponCount;
}
