import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/customer_coupons/bloc/customer_coupons_bloc.dart';

mixin CustomerCouponsMixin<T extends StatefulWidget> on State<T> {
  late final CustomerCouponsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<CustomerCouponsBloc>();
    loadCustomerCoupons();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadCustomerCoupons() {
    bloc.add(const CustomerCouponsLoad());
  }
}
