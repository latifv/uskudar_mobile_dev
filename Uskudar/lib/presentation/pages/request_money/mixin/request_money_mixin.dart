import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/presentation/pages/request_money/bloc/request_money_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/double_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';

mixin RequestMoneyMixin<T extends StatefulWidget> on State<T> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController walletController = TextEditingController();

  final FocusNode amountFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode walletFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  late final RequestMoneyBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<RequestMoneyBloc>();
    bloc.add(const RequestMoneyInitialize());
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    walletController.dispose();

    amountFocusNode.dispose();
    descriptionFocusNode.dispose();
    walletFocusNode.dispose();

    unawaited(bloc.close());
    super.dispose();
  }

  void toggleMethod(bool isPhoneMethod) {
    bloc.add(RequestMoneyToggleMethod(isPhoneMethod: isPhoneMethod));
  }

  Future<void> onSendRequest() async {
    if (!formKey.currentState!.validate()) return;

    final amount = amountController.text;
    final description = descriptionController.text;

    if (bloc.state.isPhoneMethod) {
      final phoneNumber = phoneController.text;
      showConfirmationDialog(
        amount: amount,
        recipient: phoneNumber,
        description: description,
        isPhoneMethod: true,
      );
    } else {
      final walletAddress = walletController.text;
      showConfirmationDialog(
        amount: amount,
        recipient: walletAddress,
        description: description,
        isPhoneMethod: false,
      );
    }
  }

  void blocListener(BuildContext context, RequestMoneyState state) {
    if (state.status == RequestMoneyStatus.success) {
      showSuccessDialog(
        state.requestAmount ?? '',
        state.requestRecipient ?? '',
      );
    } else if (state.status == RequestMoneyStatus.error) {
      showErrorDialog(state.message ?? '');
    }
  }

  void showSuccessDialog(String amount, String recipient) {
    context.router.pop();
    unawaited(
      CustomDialog.show(
        context: context,
        barrierDismissible: false,
        title: LocaleKeys.success.translate,
        description:
            '${LocaleKeys.request_sent_successfully.translate} ${LocaleKeys.request_amount.translate}: ${amount.toDoubleFromCurrency().toFormattedCurrency()} ${LocaleKeys.recipient.translate}: $recipient',
        icon: Icons.check_circle,
        color: Colors.green,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.ok.translate,
        surfaceButtonActive: false,
        onPrimaryButtonPressed: () {},
      ),
    );
  }

  void showErrorDialog(String message) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.error.translate,
        description: message,
        icon: Icons.error,
        color: context.colorScheme.error,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.ok.translate,
        surfaceButtonActive: false,
        onPrimaryButtonPressed: () {},
      ),
    );
  }

  void showConfirmationDialog({
    required String amount,
    required String recipient,
    required String description,
    required bool isPhoneMethod,
  }) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.approve_request.translate,
        description:
            '$recipient ${LocaleKeys.request_confirmation_description.translate} ${LocaleKeys.request_amount.translate}: ${amount.toDoubleFromCurrency().toFormattedCurrency()}',
        icon: Icons.help_outline,
        color: Colors.blue,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.yes_send.translate,
        onPrimaryButtonPressed: () {
          bloc.add(
            RequestMoneySend(
              amount: amount,
              description: description,
              walletAddress: isPhoneMethod ? null : recipient,
              phoneNumber: isPhoneMethod ? recipient : null,
            ),
          );
        },
      ),
    );
  }
}
