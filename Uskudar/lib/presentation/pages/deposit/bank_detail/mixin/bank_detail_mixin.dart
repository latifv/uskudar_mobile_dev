import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';
import 'package:uskudar_mobile/presentation/pages/deposit/bank_detail/bloc/bank_detail_bloc.dart';

mixin BankDetailMixin<T extends StatefulWidget> on State<T> {
  late final BankDetailBloc bloc;
  late final AppBank bank;

  @override
  void initState() {
    super.initState();
    bloc = getIt<BankDetailBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }
}
