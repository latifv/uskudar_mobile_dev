import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/account_limits/bloc/account_limits_bloc.dart';

mixin AccountLimitsMixin<T extends StatefulWidget> on State<T> {
  late final AccountLimitsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<AccountLimitsBloc>();
    loadAccountLimits();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadAccountLimits() {
    bloc.add(const AccountLimitsLoadData());
  }

  void refreshAccountLimits() {
    bloc.add(const AccountLimitsRefreshData());
  }
}
