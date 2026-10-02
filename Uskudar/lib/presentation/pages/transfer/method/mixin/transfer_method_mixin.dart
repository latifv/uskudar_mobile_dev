import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/core/services/contact_service.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/method/bloc/transfer_method_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/transfer/method/screen/transfer_method_screen.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/components/snackbar_component.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';

mixin TransferMethodMixin on State<TransferMethodScreen> {
  late final TextEditingController phoneController;
  late final TextEditingController walletController;

  late final GlobalKey<FormState> formKey;

  late final TransferMethodBloc bloc;
  late final ContactService contactService;

  @override
  void initState() {
    phoneController = TextEditingController();
    walletController = TextEditingController();

    formKey = GlobalKey<FormState>();

    bloc = getIt<TransferMethodBloc>();

    contactService = getIt<ContactService>();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    walletController.dispose();

    formKey.currentState?.dispose();

    unawaited(bloc.close());
    super.dispose();
  }

  Future<void> onTransferMethodLoad({TransferMethod? initialMethod}) async {
    bloc.add(TransferMethodLoad(initialMethod: initialMethod));
  }

  void onMethodSelected(TransferMethod method) {
    bloc.add(TransferMethodChanged(transferMethod: method));
  }

  void onBankAccountSelected(CustomerBank bankAccount) {
    bloc.add(BankAccountSelected(bankAccount: bankAccount));
  }

  Future<void> onQrScanPressed() async {
    unawaited(context.router.push(const QrScanRoute()));
  }

  void onContinuePressed(TransferMethodState state) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    final method = isMerchant
        ? TransferMethod.bankAccount
        : (state.method ?? TransferMethod.wallet);

    if (method == TransferMethod.wallet) {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
      bloc.add(RecipientWalletEntered(walletAddress: walletController.text));

      unawaited(
        context.router.push(
          TransferAmountRoute(
            transferMethod: TransferMethod.wallet.value,
            walletAddress: walletController.text,
          ),
        ),
      );
    } else if (method == TransferMethod.phone) {
      if (formKey.currentState == null || !formKey.currentState!.validate()) {
        return;
      }
      bloc.add(RecipientPhoneEntered(phone: phoneController.text));

      unawaited(
        context.router.push(
          TransferAmountRoute(
            transferMethod: TransferMethod.phone.value,
            phone: phoneController.text,
          ),
        ),
      );
    } else if (method == TransferMethod.bankAccount) {
      if (state.selectedBankAccount == null && state.bankAccounts.isNotEmpty) {
        SnackBarComponent.showErrorSnackBar(
          context: context,
          message: LocaleKeys.warning_select_bank_account.translate,
        );
        return;
      } else if (state.selectedBankAccount == null &&
          state.bankAccounts.isEmpty) {
        unawaited(_bankAccountDialog());
        return;
      }

      unawaited(
        context.router.push(
          TransferAmountRoute(
            transferMethod: TransferMethod.bankAccount.value,
            iban: state.selectedBankAccount!.iban,
          ),
        ),
      );
    } else {
      SnackBarComponent.showErrorSnackBar(
        context: context,
        message: LocaleKeys.error.translate,
      );
    }
  }

  Future<void> _bankAccountDialog() async {
    await CustomDialog.show(
      context: context,
      title: LocaleKeys.bank_account_add.translate,
      description: LocaleKeys.bank_account_add_description.translate,
      icon: Icons.add,
      color: context.colorScheme.primary,
      primaryButtonText: LocaleKeys.add.translate,
      onPrimaryButtonPressed: onBankAccountAddPressed,
    );
  }

  Future<void> onBankAccountAddPressed() async {
    await context.router.push(const AddBankAccountRoute());
    unawaited(onTransferMethodLoad());
  }

  Future<void> onSelectFromContacts() async {
    try {
      final contact = await contactService.pickContact();

      if (contact == null) {
        if (mounted) {
          ToastComponent.showBottomToastMessage(
            context: context,
            message: LocaleKeys.contact_selection_cancelled.translate,
          );
        }
        return;
      }

      final phoneNumber = contactService.formatPhoneNumber(contact);

      if (phoneNumber == null || phoneNumber.isEmpty) {
        if (mounted) {
          ToastComponent.showBottomToastMessage(
            context: context,
            message: LocaleKeys.invalid_phone_number_format.translate,
          );
        }
        return;
      }

      phoneController.text = phoneNumber;

      final contactName = contactService.getContactDisplayName(contact);
      if (contactName != null) {
        if (mounted) {
          ToastComponent.showSuccessToast(
            context: context,
            message: '${LocaleKeys.contact_selected.translate}: $contactName',
          );
        }
      } else {
        if (mounted) {
          ToastComponent.showSuccessToast(
            context: context,
            message: LocaleKeys.contact_selected.translate,
          );
        }
      }
    } on ContactPermissionDeniedException catch (_) {
      if (mounted) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.contacts_permission_denied.translate,
        );
      }
    } on ContactLimitedAccessException catch (_) {
      if (mounted) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.contact_limited_access_error.translate,
          duration: const Duration(seconds: 4),
        );
      }
    } on Exception catch (_) {
      if (mounted) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.contacts_access_error.translate,
        );
      }
    }
  }
}
