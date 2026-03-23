import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/bloc/gift_check_brand_detail_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

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
      loadBrandDetail();
    }
  }
}
