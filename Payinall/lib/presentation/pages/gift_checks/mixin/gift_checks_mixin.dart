import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/gift_checks/bloc/gift_checks_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';

mixin GiftChecksMixin<T extends StatefulWidget> on State<T> {
  late final GiftChecksBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<GiftChecksBloc>();
    loadCategories();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadCategories() {
    bloc.add(const GiftChecksLoadCategories());
  }

  void navigateToBrands(String categoryId, String categoryName) {
    context.router.push(
      GiftCheckBrandsRoute(categoryId: categoryId, categoryName: categoryName),
    );
  }

  void navigateToCustomerCoupons() {
    context.router.push(const CustomerCouponsRoute());
  }
}
