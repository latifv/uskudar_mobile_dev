import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/attribute_item.dart';
import 'package:payinall/domain/entities/bic_bank.dart';
import 'package:payinall/domain/entities/corporation_attribute.dart';
import 'package:payinall/domain/entities/international_transfer_result.dart';
import 'package:payinall/domain/entities/office.dart';
import 'package:payinall/domain/entities/required_attribute.dart';
import 'package:payinall/domain/entities/wallet_operator.dart';
import 'package:payinall/presentation/pages/international_money_transfer/bloc/international_money_transfer_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

mixin InternationalMoneyTransferMixin<T extends StatefulWidget> on State<T> {
  late final InternationalMoneyTransferBloc bloc;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController phoneController;
  late final TextEditingController amountController;
  late final TextEditingController countryCodeController;

  final Map<String, String> selectedAttributes = {};
  final Map<String, TextEditingController> textAttributeControllers = {};

  String selectedCountryCode = '';
  String phoneCountryCode = '90';
  bool transactionTypeDataLoaded = false;

  @override
  void initState() {
    super.initState();
    bloc = getIt<InternationalMoneyTransferBloc>();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    phoneController = TextEditingController();
    amountController = TextEditingController();
    countryCodeController = TextEditingController();
    phoneCountryCode = '90';
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    amountController.dispose();
    countryCodeController.dispose();
    for (final controller in textAttributeControllers.values) {
      controller.dispose();
    }
    unawaited(bloc.close());
    super.dispose();
  }

  void blocListener(
    BuildContext context,
    InternationalMoneyTransferState state,
  ) {
    if (state.status == InternationalMoneyTransferStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    } else if (state.status == InternationalMoneyTransferStatus.submitted &&
        state.transferResult != null) {
      navigateToConfirmation(state.transferResult!);
    } else if (state.status == InternationalMoneyTransferStatus.confirmed) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message,
      );
      navigateToResult(state.transferResult!);
    }
  }

  String selectedTransactionType = '001';

  void loadAttributes(String countryCode, {String transactionType = '001'}) {
    selectedCountryCode = countryCode;
    selectedTransactionType = transactionType;
    _resetAttributeSelections();
    bloc.add(
      InternationalMoneyTransferLoadAttributes(
        countryCode: countryCode,
        transactionType: transactionType,
      ),
    );
  }

  void loadTransactionTypeData({
    required String countryCode,
    required String transactionTypeCode,
    required String corporationCode,
    List<String>? requiredAttributeNames,
  }) {
    debugPrint(
      'loadTransactionTypeData called: country=$countryCode, type=$transactionTypeCode, corp=$corporationCode',
    );
    if (countryCode == 'TR') return;

    switch (transactionTypeCode) {
      case '011':
        final hasIban =
            requiredAttributeNames?.contains('BENEFICIARY_IBAN') ?? false;
        if (countryCode == 'US' || !hasIban) {
          bloc.add(
            InternationalMoneyTransferLoadBicBankList(
              countryCode: countryCode,
              corporationCode: corporationCode,
            ),
          );
        }
      case '001': // Cash Payout
        bloc.add(
          InternationalMoneyTransferLoadOffices(
            countryCode: countryCode,
            officeType: '001',
            corporationCode: corporationCode,
          ),
        );
      case '015': // Card
        if (countryCode == 'AZ' || countryCode == 'TJ') {
          bloc.add(
            InternationalMoneyTransferLoadCardBinCode(
              countryCode: countryCode,
            ),
          );
        }
      case '018': // Wallet
        bloc.add(
          InternationalMoneyTransferLoadWalletOperator(
            countryCode: countryCode,
          ),
        );
    }
  }

  void _resetAttributeSelections() {
    for (final controller in textAttributeControllers.values) {
      controller.dispose();
    }
    textAttributeControllers.clear();
    selectedAttributes.clear();
  }

  void initializeTextControllers(List<RequiredAttribute> attributes) {
    for (final attr in attributes) {
      if (!attr.hasSelectableItems &&
          !textAttributeControllers.containsKey(attr.displayName)) {
        textAttributeControllers[attr.displayName] = TextEditingController();
      }
    }
  }

  void onAttributeSelected(String displayName, AttributeItem item) {
    selectedAttributes[displayName] = item.code;
  }

  void onBankSelected(BicBank bank) {
    selectedAttributes['BENEFICIARY_BANK_BIC_CODE'] = bank.branchCode;
    selectedAttributes['BENEFICIARY_BANK_CODE'] = bank.code;
  }

  void onOfficeSelected(Office office) {
    selectedAttributes['BENEFICIARY_OFFICE'] = office.officeCode;
  }

  void onWalletOperatorSelected(WalletOperator operator) {
    selectedAttributes['WALLET_OPERATOR_CODE'] = operator.operatorCode;
  }

  void onTextAttributeChanged(String displayName, String value) {
    selectedAttributes[displayName] = value;
  }

  TextEditingController getTextController(String displayName) {
    if (!textAttributeControllers.containsKey(displayName)) {
      textAttributeControllers[displayName] = TextEditingController();
    }
    return textAttributeControllers[displayName]!;
  }

  void onSubmitPressed() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;

    if (selectedCountryCode.isEmpty) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.required_field.translate,
      );
      return;
    }

    final selectedCorporation = bloc.state.selectedCorporation;
    if (selectedCorporation == null) {
      ToastComponent.showErrorToast(
        context: context,
        message: LocaleKeys.general_error.translate,
      );
      return;
    }

    final attributesToSend = <String, String>{};

    for (final attribute in selectedCorporation.requiredAttributeList) {
      if (attribute.hasSelectableItems) {
        final selectedValue = selectedAttributes[attribute.displayName];
        if (selectedValue == null) {
          ToastComponent.showErrorToast(
            context: context,
            message: LocaleKeys.required_field.translate,
          );
          return;
        }
        attributesToSend[attribute.displayName] = selectedValue;
        continue;
      }

      final controller = getTextController(attribute.displayName);
      final value = controller.text.trim();
      if (value.isEmpty) {
        ToastComponent.showErrorToast(
          context: context,
          message: LocaleKeys.required_field.translate,
        );
        return;
      }
      attributesToSend[attribute.displayName] = value;
    }

    if (selectedAttributes.containsKey('BENEFICIARY_BANK_BIC_CODE')) {
      attributesToSend['BENEFICIARY_BANK_BIC_CODE'] =
          selectedAttributes['BENEFICIARY_BANK_BIC_CODE']!;
    }
    if (selectedAttributes.containsKey('BENEFICIARY_BANK_CODE')) {
      attributesToSend['BENEFICIARY_BANK_CODE'] =
          selectedAttributes['BENEFICIARY_BANK_CODE']!;
    }

    if (selectedAttributes.containsKey('BENEFICIARY_OFFICE')) {
      attributesToSend['BENEFICIARY_OFFICE'] =
          selectedAttributes['BENEFICIARY_OFFICE']!;
    }

    selectedAttributes
      ..clear()
      ..addAll(attributesToSend);

    final amount = amountController.text.toDoubleFromCurrency();
    final formattedPhoneCountryCode = phoneCountryCode.padLeft(3, '0');

    final currencyCode = selectedCorporation.currencyCode;
    final moneyTakenCurrency = currencyCode == 'All Currency'
        ? 'TRY'
        : currencyCode;

    bloc.add(
      InternationalMoneyTransferSubmit(
        beneficiaryCountryCode: selectedCountryCode,
        beneficiaryName: nameController.text,
        beneficiarySurname: surnameController.text,
        beneficiaryGsmCountryCode: formattedPhoneCountryCode,
        beneficiaryGsmNo: phoneController.text,
        amount: amount,
        moneyTakenCurrency: moneyTakenCurrency,
        transactionType: selectedTransactionType,
        transferType: '',
        requiredAttributes: attributesToSend,
      ),
    );
  }

  void onConfirmPressed(InternationalTransferResult result) {
    bloc.add(
      InternationalMoneyTransferConfirm(
        transactionId: result.transactionNumber,
      ),
    );
  }

  void navigateToResult(InternationalTransferResult result) {
    unawaited(
      context.router.replaceAll([
        const HomeRoute(),
        InternationalTransferResultRoute(transferResult: result),
      ]),
    );
  }

  void navigateToConfirmation(InternationalTransferResult result) {
    unawaited(
      context.router.push(
        InternationalTransferConfirmationRoute(transferResult: result),
      ),
    );
  }

  void onCorporationSelected(CorporationAttribute corporation) {
    _resetAttributeSelections();
    bloc.add(
      InternationalMoneyTransferSelectCorporation(corporation: corporation),
    );
    initializeTextControllers(corporation.requiredAttributeList);

    final attributeNames = corporation.requiredAttributeList
        .map((attr) => attr.displayName)
        .toList();

    loadTransactionTypeData(
      countryCode: selectedCountryCode,
      transactionTypeCode: selectedTransactionType,
      corporationCode: corporation.corporationCode,
      requiredAttributeNames: attributeNames,
    );
  }
}
