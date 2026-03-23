import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';
import 'package:payinall/domain/entities/frequently_sent.dart';
import 'package:payinall/domain/validators/app_validators.dart';
import 'package:payinall/presentation/pages/registered_users/bloc/registered_users_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';

mixin RegisteredUsersMixin<T extends StatefulWidget> on State<T> {
  late final RegisteredUsersBloc bloc;
  late final TabController tabController;
  late final bool isMerchant;

  // Add user form
  late final TextEditingController customerNumberController;
  late final GlobalKey<FormState> addUserFormKey;

  // Add iban form
  late final TextEditingController ibanController;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final GlobalKey<FormState> addIbanFormKey;

  void initRegisteredUsersMixin(TickerProvider vsync) {
    bloc = getIt<RegisteredUsersBloc>();
    isMerchant = getIt<UserInfoManager>().isMerchant;
    tabController = TabController(
      length: isMerchant ? 1 : 1,
      vsync: vsync,
    );
    tabController.addListener(_handleTabChange);

    customerNumberController = TextEditingController();
    addUserFormKey = GlobalKey<FormState>();

    ibanController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addIbanFormKey = GlobalKey<FormState>();

    loadData();
  }

  void disposeRegisteredUsersMixin() {
    tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    customerNumberController.dispose();
    addUserFormKey.currentState?.dispose();
    ibanController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    addIbanFormKey.currentState?.dispose();
    unawaited(bloc.close());
  }

  void loadData() {
    bloc.add(const RegisteredUsersLoad());
  }

  void _handleTabChange() {
    if (!tabController.indexIsChanging) return;
    bloc.add(RegisteredUsersTabChanged(tabIndex: tabController.index));
  }

  void onAddUserPressed() {
    customerNumberController.clear();
    _showAddUserDialog();
  }

  void onAddIbanPressed() {
    ibanController.clear();
    firstNameController.clear();
    lastNameController.clear();
    _showAddIbanDialog();
  }

  void onDeleteUser(FrequentlySent user) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.delete_registered_user.translate,
        description: LocaleKeys.delete_registered_user_confirmation.translate,
        icon: Icons.delete_outline,
        color: context.colorScheme.error,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.yes_delete.translate,
        onPrimaryButtonPressed: () {
          bloc.add(RegisteredUsersDeleteUser(id: user.id));
        },
      ),
    );
  }

  void onDeleteIban(FrequentIban iban) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.delete_registered_iban.translate,
        description: LocaleKeys.delete_registered_iban_confirmation.translate,
        icon: Icons.delete_outline,
        color: context.colorScheme.error,
        textColor: context.colorScheme.surface,
        primaryButtonText: LocaleKeys.yes_delete.translate,
        onPrimaryButtonPressed: () {
          bloc.add(RegisteredUsersDeleteIban(id: iban.id));
        },
      ),
    );
  }

  void blocListener(BuildContext context, RegisteredUsersState state) {
    if (state.status == RegisteredUsersStatus.actionSuccess) {
      if (state.message != null) {
        ToastComponent.showSuccessToast(
          context: context,
          message: state.message,
        );
      }
      loadData();
    } else if (state.status == RegisteredUsersStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    }
  }

  void _showAddUserDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: Padding(
            padding: dialogContext.paddingBaseLow,
            child: Form(
              key: addUserFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  dialogContext.spacingNormalHeight,
                  Text(
                    LocaleKeys.add_registered_user.translate,
                    style: dialogContext.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dialogContext.spacingNormalHeight,
                  CustomTextFormField(
                    controller: customerNumberController,
                    hintText: LocaleKeys.enter_customer_number.translate,
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(
                      Icons.person_search_outlined,
                    ),
                    validator: (value) => AppValidators.required(
                      value,
                      LocaleKeys.customer_number_required.translate,
                    ),
                  ),
                  dialogContext.spacingNormalHeight,
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(dialogContext).unfocus();
                      if (addUserFormKey.currentState?.validate() != true) {
                        return;
                      }
                      Navigator.of(dialogContext).pop();
                      bloc.add(
                        RegisteredUsersAddUser(
                          customerNumber: customerNumberController.text,
                        ),
                      );
                    },
                    child: Text(LocaleKeys.add.translate),
                  ),
                  dialogContext.spacingNormalHeight,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddIbanDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (dialogContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          ),
          child: Padding(
            padding: dialogContext.paddingBaseLow,
            child: Form(
              key: addIbanFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  dialogContext.spacingNormalHeight,
                  Text(
                    LocaleKeys.add_registered_iban.translate,
                    style: dialogContext.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  dialogContext.spacingNormalHeight,
                  CustomTextFormField(
                    controller: ibanController,
                    hintText: LocaleKeys.enter_iban_no.translate,
                    keyboardType: TextInputType.text,
                    prefixIcon: const Icon(Icons.account_balance_outlined),
                    validator: (value) => AppValidators.required(
                      value,
                      LocaleKeys.iban_no_required.translate,
                    ),
                  ),
                  dialogContext.spacingLowHeight,
                  CustomTextFormField(
                    controller: firstNameController,
                    hintText: LocaleKeys.enter_first_name.translate,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) => AppValidators.required(
                      value,
                      LocaleKeys.first_name_required.translate,
                    ),
                  ),
                  dialogContext.spacingLowHeight,
                  CustomTextFormField(
                    controller: lastNameController,
                    hintText: LocaleKeys.enter_last_name.translate,
                    keyboardType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) => AppValidators.required(
                      value,
                      LocaleKeys.last_name_required.translate,
                    ),
                  ),
                  dialogContext.spacingNormalHeight,
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(dialogContext).unfocus();
                      if (addIbanFormKey.currentState?.validate() != true) {
                        return;
                      }
                      Navigator.of(dialogContext).pop();
                      bloc.add(
                        RegisteredUsersAddIban(
                          ibanNo: ibanController.text,
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                        ),
                      );
                    },
                    child: Text(LocaleKeys.add.translate),
                  ),
                  dialogContext.spacingNormalHeight,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
