import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_category.dart';
import 'package:uskudar_mobile/presentation/pages/gift_checks/bloc/gift_checks_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';

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

  void navigateToCategory(GiftCheckCategory category) {
    if (category.isLioCard) {
      unawaited(context.router.push(const MetropolRoute()));
      return;
    }

    unawaited(
      context.router.push(
        GiftCheckBrandsRoute(
          categoryId: category.id,
          categoryName: category.name,
        ),
      ),
    );
  }

  void navigateToCustomerCoupons() {
    unawaited(context.router.push(const CustomerCouponsRoute()));
  }
}
