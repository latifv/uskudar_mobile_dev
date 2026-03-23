import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/qr_operation/generate/bloc/qr_generate_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/snackbar_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin QrGenerateMixin<T extends StatefulWidget> on State<T> {
  late final QrGenerateBloc bloc;
  late final TextEditingController amountController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    bloc = getIt<QrGenerateBloc>();
    amountController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    amountController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  void onGenerateQrPressed() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    final amount = amountController.text.toDoubleFromCurrency();
    final userInfoManager = getIt<UserInfoManager>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final qrColor = isDarkMode ? Colors.white : Colors.black;

    bloc.add(
      QrGenerateFormSubmitted(
        amount: amount,
        walletAddress: userInfoManager.walletAddress ?? '0',
        qrColor: qrColor,
      ),
    );
  }

  void blocListener(_, QrGenerateState state) {
    if (state is QrGenerateSuccess) {
      _navigateToDisplayScreen(state);
    } else if (state is QrGenerateError) {
      SnackBarComponent.showErrorSnackBar(
        context: context,
        message: state.message,
      );
    }
  }

  void _navigateToDisplayScreen(QrGenerateSuccess state) {
    unawaited(
      context.router.replace(
        QrDisplayRoute(qrImage: state.qrImage, amount: state.amount),
      ),
    );
  }
}
