part of 'gift_check_brand_detail_bloc.dart';

enum GiftCheckBrandDetailStatus {
  initial,
  loading,
  loaded,
  takingCoupon,
  couponTaken,
  error,
}

final class GiftCheckBrandDetailState extends Equatable {
  const GiftCheckBrandDetailState({
    this.status = GiftCheckBrandDetailStatus.initial,
    this.brandDetail,
    this.coupons,
    this.message,
    this.selectedCouponId,
  });

  final GiftCheckBrandDetailStatus status;
  final GiftCheckBrandDetail? brandDetail;
  final List<GiftCheckCoupon>? coupons;
  final String? message;
  final String? selectedCouponId;

  GiftCheckBrandDetailState copyWith({
    GiftCheckBrandDetailStatus? status,
    GiftCheckBrandDetail? brandDetail,
    List<GiftCheckCoupon>? coupons,
    String? message,
    String? selectedCouponId,
    bool clearSelectedCoupon = false,
  }) {
    return GiftCheckBrandDetailState(
      status: status ?? this.status,
      brandDetail: brandDetail ?? this.brandDetail,
      coupons: coupons ?? this.coupons,
      message: message,
      selectedCouponId: clearSelectedCoupon
          ? null
          : selectedCouponId ?? this.selectedCouponId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    brandDetail,
    coupons,
    message,
    selectedCouponId,
  ];
}
