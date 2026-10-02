import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brands/bloc/gift_check_brands_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';

mixin GiftCheckBrandsMixin<T extends StatefulWidget> on State<T> {
  late final GiftCheckBrandsBloc bloc;

  String get categoryId;

  @override
  void initState() {
    super.initState();
    bloc = getIt<GiftCheckBrandsBloc>();
    loadBrands();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadBrands() {
    bloc.add(GiftCheckBrandsLoad(categoryId: categoryId));
  }

  void navigateToBrandDetail(String brandId) {
    unawaited(
      context.router.push(GiftCheckBrandDetailRoute(brandId: brandId)),
    );
  }
}
