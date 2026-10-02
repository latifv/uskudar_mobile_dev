import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/international_transfer_result.dart';
import 'package:uskudar_mobile/presentation/pages/international_money_transfer/bloc/international_money_transfer_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin InternationalTransferConfirmationMixin<T extends StatefulWidget>
    on State<T> {
  late final InternationalMoneyTransferBloc bloc;
  late InternationalTransferResult transferResult;

  @override
  void initState() {
    super.initState();
    bloc = getIt<InternationalMoneyTransferBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(
    BuildContext context,
    InternationalMoneyTransferState state,
  ) {
    if (state.status == InternationalMoneyTransferStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    } else if (state.status == InternationalMoneyTransferStatus.confirmed) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message,
      );
      navigateToResult();
    }
  }

  void onConfirmPressed() {
    bloc.add(
      InternationalMoneyTransferConfirm(
        transactionId: transferResult.transactionNumber,
      ),
    );
  }

  void navigateToResult() {
    unawaited(
      context.router.replaceAll([
        const HomeRoute(),
        InternationalTransferResultRoute(transferResult: transferResult),
      ]),
    );
  }
}
