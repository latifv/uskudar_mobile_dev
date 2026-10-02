import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/faq/bloc/faq_bloc.dart';

mixin FaqMixin<T extends StatefulWidget> on State<T> {
  late final FaqBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<FaqBloc>();
    loadFaqData();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadFaqData() {
    bloc.add(const FaqLoadData());
  }

  void toggleFaqExpanded(int index) {
    bloc.add(FaqToggleExpanded(index: index));
  }
}
