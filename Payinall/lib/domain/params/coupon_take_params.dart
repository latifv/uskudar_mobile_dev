class CouponTakeParams {
  const CouponTakeParams({
    required this.brandId,
    required this.couponId,
    required this.couponCount,
  });

  final String brandId;
  final String couponId;
  final int couponCount;
}
