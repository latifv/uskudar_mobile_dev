import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/bloc/fuel_card_top_up_bloc.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/fuel_card_top_up_screen.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin FuelCardTopUpMixin on State<FuelCardTopUpScreen> {
  late final FuelCardTopUpBloc bloc;
  late final TextEditingController amountController;
  late final GlobalKey<FormState> formKey;

  int get fuelCardId => widget.fuelCardId;
  String get cardNo => widget.cardNo;

  @override
  void initState() {
    super.initState();
    bloc = getIt<FuelCardTopUpBloc>();
    amountController = TextEditingController();
    formKey = GlobalKey<FormState>();
    loadBalance();
  }

  @override
  void dispose() {
    amountController.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void loadBalance() {
    bloc.add(FuelCardTopUpLoadBalance(fuelCardId: fuelCardId));
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;

    final amount = amountController.text.trim().toDoubleFromCurrency();

    bloc.add(
      FuelCardTopUpSubmit(
        fuelCardId: fuelCardId,
        amount: amount,
      ),
    );
  }

  void blocListener(BuildContext context, FuelCardTopUpState state) {
    if (state.status == FuelCardTopUpStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == FuelCardTopUpStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? '',
      );
      context.router.maybePop();
    }
  }
}
