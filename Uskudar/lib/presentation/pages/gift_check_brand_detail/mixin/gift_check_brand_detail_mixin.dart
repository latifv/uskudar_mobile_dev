import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brand_detail/bloc/gift_check_brand_detail_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin GiftCheckBrandDetailMixin<T extends StatefulWidget> on State<T> {
  late final GiftCheckBrandDetailBloc bloc;

  String get brandId;

  @override
  void initState() {
    super.initState();
    bloc = getIt<GiftCheckBrandDetailBloc>();
    loadBrandDetail();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadBrandDetail() {
    bloc.add(GiftCheckBrandDetailLoad(brandId: brandId));
  }

  void takeCoupon({required String couponId, required int couponCount}) {
    bloc.add(
      GiftCheckBrandDetailTakeCoupon(
        brandId: brandId,
        couponId: couponId,
        couponCount: couponCount,
      ),
    );
  }

  void selectCoupon(String couponId) {
    bloc.add(GiftCheckBrandDetailSelectCoupon(couponId: couponId));
  }

  void blocListener(
    BuildContext context,
    GiftCheckBrandDetailState state,
  ) {
    if (state.status == GiftCheckBrandDetailStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == GiftCheckBrandDetailStatus.couponTaken) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? '',
      );
      unawaited(_showPurchasedCoupon());
    }
  }

  Future<void> _showPurchasedCoupon() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    await context.router.push(const CustomerCouponsRoute());
    if (mounted) loadBrandDetail();
  }
}
