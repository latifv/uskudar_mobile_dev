import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/gift_check_brands/bloc/gift_check_brands_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';

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
    context.router.push(GiftCheckBrandDetailRoute(brandId: brandId));
  }
}
