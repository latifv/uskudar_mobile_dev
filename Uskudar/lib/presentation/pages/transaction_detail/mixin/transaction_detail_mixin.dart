import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/transaction_detail/bloc/transaction_detail_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/launch_url_extension.dart';

mixin TransactionDetailMixin<T extends StatefulWidget> on State<T> {
  late final TransactionDetailBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<TransactionDetailBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(_, TransactionDetailState state) {
    if (state.status == TransactionDetailStatus.error &&
        state.message != null) {
      ToastComponent.showTopToastMessage(
        context: context,
        message: state.message,
      );
    }
  }

  void onLoadData(String transactionId) {
    bloc.add(TransactionDetailLoadData(transactionId));
  }

  Future<void> onOpenReceiptUrl(String url) async {
    if (url.isEmpty) return;

    unawaited(url.launchAsUrl());
  }
}
