import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/amount/bloc/transfer_amount_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

mixin TransferAmountMixin<T extends StatefulWidget> on State<T> {
  late final TransferAmountBloc bloc;
  late final TransferMethod transferMethod;
  late final String? phone;
  late final String? walletAddress;
  late final String? iban;
  late final TextEditingController ibanController;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController descriptionController;
  late final TextEditingController amountController;
  late final FocusNode amountFocusNode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    bloc = getIt<TransferAmountBloc>();
    amountController = TextEditingController();
    ibanController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    descriptionController = TextEditingController();
    amountFocusNode = FocusNode();
    amountFocusNode.requestFocus();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    amountController.dispose();
    ibanController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    descriptionController.dispose();
    amountFocusNode.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  void blocListener(BuildContext context, TransferAmountState state) {
    if (state.status == TransferAmountStatus.success) {
      unawaited(
        context.router.push(
          TransferConfirmationRoute(
            transferMethod: transferMethod,
            walletTransfer: state.walletTransfer,
            withdrawTransfer: state.withdrawTransfer,
          ),
        ),
      );
    } else if (state.status == TransferAmountStatus.error) {
      ToastComponent.showErrorToast(context: context, message: state.message);
    }
  }

  void onContinuePressed({String? quickAmount}) {
    if (quickAmount == null) {
      if (formKey.currentState?.validate() != true) return;
    }

    final amount = quickAmount != null
        ? quickAmount.toDoubleFromCurrency()
        : amountController.text.toDoubleFromCurrency();
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    var submitIban = iban;
    String? desc;
    if (transferMethod == TransferMethod.bankAccount) {
      if (submitIban == null || submitIban.isEmpty) {
        final manualIban = ibanController.text.trim();
        if (manualIban.isNotEmpty) {
          submitIban = manualIban;
        }
      }
      if (isMerchant) {
        final manualDesc = descriptionController.text.trim();
        if (manualDesc.isNotEmpty) {
          desc = manualDesc;
        } else {
          desc = null;
        }
      }
    }
    if (isMerchant) {
      if (desc == null || desc.isEmpty) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.description_required.translate,
        );
        return;
      }
    }

    if (isMerchant &&
        transferMethod == TransferMethod.bankAccount &&
        (iban == null || iban!.isEmpty)) {
      ToastComponent.showErrorToast(
        context: context,
        message: 'Lütfen firma hesabı listesinden bir IBAN seçin.',
      );
      return;
    }

    bloc.add(
      TransferAmountSubmitted(
        transferMethod: transferMethod,
        amount: amount,
        phone: phone,
        walletAddress: walletAddress,
        iban: submitIban?.replaceAll(' ', ''),
        description: desc,
      ),
    );
  }
}
