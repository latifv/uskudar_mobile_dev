import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/commission_rates/bloc/commission_rates_bloc.dart';

mixin CommissionRatesMixin<T extends StatefulWidget> on State<T> {
  late final CommissionRatesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<CommissionRatesBloc>();
    loadData();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadData() {
    bloc.add(const CommissionRatesLoadData());
  }
}
