import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_gift_transfer/bloc/metropol_gift_transfer_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin MetropolGiftTransferMixin<T extends StatefulWidget> on State<T> {
  late final MetropolGiftTransferBloc bloc;
  late final TextEditingController amountController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    bloc = getIt<MetropolGiftTransferBloc>();
    amountController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    amountController.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void onSubmitTransfer() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;

    final amount = amountController.text.toDoubleFromCurrency();
    bloc.add(MetropolGiftTransferSubmit(amount: amount));
  }

  void onDrawBack() {
    bloc.add(const MetropolGiftTransferDrawBack());
  }

  void blocListener(
    BuildContext context,
    MetropolGiftTransferState state,
  ) {
    if (state.status == MetropolGiftTransferStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == MetropolGiftTransferStatus.completed) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? 'İşlem başarılı!',
      );
      context.router.maybePop();
    }
    if (state.status == MetropolGiftTransferStatus.drawBackCompleted) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? 'Geri yükleme başarılı!',
      );
    }
  }
}
