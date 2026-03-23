import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/add_fuel_card/bloc/add_fuel_card_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin AddFuelCardMixin<T extends StatefulWidget> on State<T> {
  late final AddFuelCardBloc bloc;
  late final TextEditingController cardNoController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    bloc = getIt<AddFuelCardBloc>();
    cardNoController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    cardNoController.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    bloc.add(
      AddFuelCardSubmit(
        cardNo: cardNoController.text.trim(),
        cardType: 3,
      ),
    );
  }

  void blocListener(BuildContext context, AddFuelCardState state) {
    if (state.status == AddFuelCardStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == AddFuelCardStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? '',
      );
      context.router.maybePop();
    }
  }
}
