import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/wrong_login_attempts/bloc/wrong_login_attempts_bloc.dart';

mixin WrongLoginAttemptsMixin<T extends StatefulWidget> on State<T> {
  late final WrongLoginAttemptsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<WrongLoginAttemptsBloc>();
    loadWrongLoginAttemptsData();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadWrongLoginAttemptsData() {
    bloc.add(const WrongLoginAttemptsLoadData());
  }
}
