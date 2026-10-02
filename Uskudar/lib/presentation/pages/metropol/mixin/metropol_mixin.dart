import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/metropol/bloc/metropol_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin MetropolMixin<T extends StatefulWidget> on State<T> {
  late final MetropolBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<MetropolBloc>();
    loadMetropol();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadMetropol() {
    bloc.add(const MetropolLoad());
  }

  void refreshBalance() {
    bloc.add(const MetropolRefreshBalance());
  }

  void navigateToLocations() {
    unawaited(context.router.push(const MetropolLocationsRoute()));
  }

  void navigateToTransactions() {
    unawaited(context.router.push(const MetropolTransactionsRoute()));
  }

  void navigateToTransfer() {
    unawaited(
      context.router.push(const MetropolTransferRoute()).then((_) {
        refreshBalance();
      }),
    );
  }

  void navigateToGiftTransfer() {
    unawaited(
      context.router.push(const MetropolGiftTransferRoute()).then((_) {
        refreshBalance();
      }),
    );
  }

  void blocListener(BuildContext context, MetropolState state) {
    if (state.status == MetropolStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
  }
}
