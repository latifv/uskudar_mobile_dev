import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_event.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/bloc/receive_money_state.dart';
import 'package:uskudar_mobile/presentation/pages/receive_money/screen/receive_money_screen.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin ReceiveMoneyMixin on State<ReceiveMoneyScreen> {
  late final ReceiveMoneyBloc bloc;
  late final TextEditingController referenceController;
  late final FocusNode referenceFocusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    bloc = getIt<ReceiveMoneyBloc>();
    referenceController = TextEditingController();
    referenceFocusNode = FocusNode();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    referenceController.dispose();
    referenceFocusNode.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(BuildContext context, ReceiveMoneyState state) {
    if (state.status == ReceiveMoneyStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    }
    if (state.status == ReceiveMoneyStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message,
      );
      _navigateToDashboard();
    }
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    bloc.add(
      ReceiveMoneySubmitted(
        referenceNumber: referenceController.text.trim(),
      ),
    );
  }

  void _navigateToDashboard() {
    unawaited(context.router.replaceAll([const DashboardRoute()]));
  }
}
