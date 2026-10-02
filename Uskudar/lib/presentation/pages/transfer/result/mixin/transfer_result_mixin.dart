import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/utils/app_utils.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/home/bloc/home_bloc.dart';
import 'package:payinall/presentation/pages/transfer/result/bloc/transfer_result_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/launch_url_extension.dart';

mixin TransferResultMixin<T extends StatefulWidget> on State<T> {
  late final TransferResultBloc _transferResultBloc;
  late final String transactionId;
  late final bool isSuccess;

  @override
  void initState() {
    super.initState();
    _transferResultBloc = getIt<TransferResultBloc>();

    if (transactionId.isNotEmpty) {
      _transferResultBloc.add(
        TransferResultLoadReceipt(
          transactionId: transactionId,
          isSuccess: isSuccess,
        ),
      );
    } else {
      _transferResultBloc.add(TransferResultUpdateStatus(isSuccess: isSuccess));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> openReceiptURL(String? url) async {
    if (url == null || url.isEmpty) return;

    unawaited(url.launchAsUrl());
  }

  TransferResultBloc get transferResultBloc => _transferResultBloc;

  void onHomePressed() {
    context.router.popUntilRoot();
    getIt<HomeBloc>().add(const HomeRefreshTransactions());
    getIt<HomeBloc>().add(const HomeRefreshBalance());
  }

  void onTransactionsPressed() {
    context.router.popUntil(
      (route) => route.settings.name == DashboardRoute.name,
    );
    unawaited(context.navigateTo(const TransactionHistoryRoute()));
  }

  void onMainMenuPressed() {
    context.router.popUntilRoot();
  }

  void onCopyPressed(String transactionNumber, BuildContext context) {
    unawaited(AppUtils.copyToClipboard(transactionNumber, context));
  }
}
