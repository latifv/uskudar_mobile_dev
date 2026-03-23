import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/account_limits/bloc/account_limits_bloc.dart';

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
