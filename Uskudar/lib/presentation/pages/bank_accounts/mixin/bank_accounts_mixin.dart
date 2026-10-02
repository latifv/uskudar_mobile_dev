import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/utils/app_utils.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/presentation/pages/bank_accounts/bloc/bank_accounts_bloc.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';

mixin BankAccountsMixin<T extends StatefulWidget> on State<T> {
  late final BankAccountsBloc bloc;

  @override
  void initState() {
    bloc = getIt<BankAccountsBloc>();
    loadBankAccounts();
    super.initState();
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void loadBankAccounts() {
    bloc.add(const BankAccountsLoad());
  }

  void onDeleteAccount(CustomerBank account) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.delete_bank_account.translate,
        description:
            '${account.bankName} - ${account.title} ${LocaleKeys.delete_bank_account_description.translate}',
        icon: Icons.warning,
        primaryButtonText: LocaleKeys.delete.translate,
        onPrimaryButtonPressed: () {
          bloc.add(BankAccountsDelete(ibanNumber: account.iban));
        },
        color: context.colorScheme.error,
      ),
    );
  }

  Future<void> onAddAccount() async {
    await context.router.push(const AddBankAccountRoute());
    loadBankAccounts();
  }

  void onCopyIban(String iban) {
    unawaited(AppUtils.copyToClipboard(iban, context));
  }
}
