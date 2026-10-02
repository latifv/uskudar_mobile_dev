import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/wallet_transfer.dart';
import 'package:payinall/domain/entities/withdraw_transfer.dart';
import 'package:payinall/presentation/pages/transfer/confirmation/bloc/transfer_confirmation_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';

mixin TransferConfirmationMixin<T extends StatefulWidget> on State<T> {
  late final TransferConfirmationBloc bloc;
  late final WalletTransfer? walletTransfer;
  late final WithdrawTransfer? withdrawTransfer;

  @override
  void initState() {
    super.initState();
    bloc = getIt<TransferConfirmationBloc>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void onConfirmPressed() {
    bloc.add(
      TransferConfirmationSubmit(
        walletTransfer: walletTransfer,
        withdrawTransfer: withdrawTransfer,
      ),
    );
  }

  void onTransferSuccess(String transactionId) {
    unawaited(
      context.router.replaceAll([
        const HomeRoute(),
        TransferResultRoute(transactionId: transactionId),
      ]),
    );
  }

  void onTransferError(String transactionId, String errorMessage) {
    unawaited(
      context.router.replaceAll([
        const HomeRoute(),
        TransferResultRoute(
          isSuccess: false,
          transactionId: transactionId,
          errorMessage: errorMessage,
        ),
      ]),
    );
  }
}
