import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/gift_check_brand_detail.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/domain/params/coupon_take_params.dart';
import 'package:payinall/domain/usecases/coupon_take_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_brand_detail_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_coupons_usecase.dart';

part 'gift_check_brand_detail_event.dart';
part 'gift_check_brand_detail_state.dart';

final class GiftCheckBrandDetailBloc
    extends Bloc<GiftCheckBrandDetailEvent, GiftCheckBrandDetailState> {
  GiftCheckBrandDetailBloc({
    required this.getGiftCheckBrandDetailUsecase,
    required this.getGiftCheckCouponsUsecase,
    required this.couponTakeUsecase,
  }) : super(const GiftCheckBrandDetailState()) {
    on<GiftCheckBrandDetailLoad>(_loadBrandPage);
    on<GiftCheckBrandDetailTakeCoupon>(_takeCoupon);
  }

  final GetGiftCheckBrandDetailUsecase getGiftCheckBrandDetailUsecase;
  final GetGiftCheckCouponsUsecase getGiftCheckCouponsUsecase;
  final CouponTakeUsecase couponTakeUsecase;

  Future<void> _loadBrandPage(
    GiftCheckBrandDetailLoad event,
    Emitter<GiftCheckBrandDetailState> emit,
  ) async {
    emit(state.copyWith(status: GiftCheckBrandDetailStatus.loading));

    final detailResult =
        await getGiftCheckBrandDetailUsecase(event.brandId);
    final couponsResult =
        await getGiftCheckCouponsUsecase(event.brandId);

    final detailFailed = detailResult.isLeft();
    final couponsFailed = couponsResult.isLeft();

    if (detailFailed) {
      final failure = detailResult.getLeft().toNullable();
      emit(
        state.copyWith(
          status: GiftCheckBrandDetailStatus.error,
          message: failure?.message,
        ),
      );
      return;
    }

    if (couponsFailed) {
      final failure = couponsResult.getLeft().toNullable();
      emit(
        state.copyWith(
          status: GiftCheckBrandDetailStatus.error,
          message: failure?.message,
        ),
      );
      return;
    }

    final brandDetail = detailResult.getRight().toNullable();
    final coupons = couponsResult.getRight().toNullable();

    emit(
      state.copyWith(
        status: GiftCheckBrandDetailStatus.loaded,
        brandDetail: brandDetail,
        coupons: coupons,
      ),
    );
  }

  Future<void> _takeCoupon(
    GiftCheckBrandDetailTakeCoupon event,
    Emitter<GiftCheckBrandDetailState> emit,
  ) async {
    emit(state.copyWith(status: GiftCheckBrandDetailStatus.takingCoupon));

    final result = await couponTakeUsecase(
      CouponTakeParams(
        brandId: event.brandId,
        couponId: event.couponId,
        couponCount: event.couponCount,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: GiftCheckBrandDetailStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: GiftCheckBrandDetailStatus.couponTaken,
          message: message,
        ),
      ),
    );
  }
}
