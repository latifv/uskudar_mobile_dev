import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/enums/transfer_method.dart';
import 'package:payinall/presentation/pages/registered_users/widgets/frequently_sent_card.dart';
import 'package:payinall/presentation/pages/transfer/method/bloc/transfer_method_bloc.dart';
import 'package:payinall/presentation/pages/transfer/method/mixin/transfer_method_mixin.dart';
import 'package:payinall/presentation/pages/transfer/method/widgets/bank_account_list.dart';
import 'package:payinall/presentation/pages/transfer/method/widgets/recipient_input_section.dart';
import 'package:payinall/presentation/pages/transfer/method/widgets/transfer_method_selector.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class TransferMethodScreen extends StatefulWidget {
  const TransferMethodScreen({super.key, this.isWithdraw = false});

  final bool isWithdraw;

  @override
  State<TransferMethodScreen> createState() => _TransferMethodScreenState();
}

final class _TransferMethodScreenState extends State<TransferMethodScreen>
    with TransferMethodMixin {
  @override
  void initState() {
    super.initState();
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    final initialMethod = (widget.isWithdraw || isMerchant)
        ? TransferMethod.bankAccount
        : null;
    Future.microtask(() => onTransferMethodLoad(initialMethod: initialMethod));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.transfer_money.translate)),
      body: BlocProvider(
        create: (context) => bloc,
        child: BlocBuilder<TransferMethodBloc, TransferMethodState>(
          builder: (context, state) {
            switch (state.status) {
              case TransferMethodStatus.initial:
              case TransferMethodStatus.loading:
                return const Center(child: CustomLoading());
              case TransferMethodStatus.error:
                return ErrorTryAgain(
                  message: state.message ?? LocaleKeys.unknown_error.translate,
                  onTryAgain: onTransferMethodLoad,
                );
              case TransferMethodStatus.loaded:
                return _buildContent(context, state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransferMethodState state) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    return SafeArea(
      child: Padding(
        padding: context.paddingBaseLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(context),
                    context.spacingNormalHeight,
                    if (!isMerchant)
                      TransferMethodSelector(
                        onMethodSelected: onMethodSelected,
                        selectedMethod: state.method ?? TransferMethod.wallet,
                      ),
                    context.spacingNormalHeight,
                    if (isMerchant) ...[
                      Text(
                        'Yalnızca firmana tanımlı hesaplara transfer yapabilirsin.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      context.spacingLowHeight,
                      BankAccountList(
                        bankAccounts: state.bankAccounts,
                        selectedBankAccount: state.selectedBankAccount,
                        onBankAccountSelected: onBankAccountSelected,
                      ),
                    ] else ...[
                      if (state.method == TransferMethod.bankAccount)
                        BankAccountList(
                          bankAccounts: state.bankAccounts,
                          selectedBankAccount: state.selectedBankAccount,
                          onBankAccountSelected: onBankAccountSelected,
                        )
                      else
                        RecipientInputSection(
                          transferMethod: state.method ?? TransferMethod.wallet,
                          phoneController: phoneController,
                          walletController: walletController,
                          formKey: formKey,
                          onSelectFromContacts: onSelectFromContacts,
                          onQrScanPressed: onQrScanPressed,
                        ),
                      if (state.frequentlySents.isNotEmpty &&
                          state.method != TransferMethod.bankAccount) ...[
                        context.spacingNormalHeight,
                        Text(
                          LocaleKeys.registered_users_select.translate,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        context.spacingLowHeight,
                        ...state.frequentlySents.map(
                          (user) => Padding(
                            padding: context.paddingLowBottom,
                            child: FrequentlySentCard(
                              user: user,
                              showDelete: false,
                              onTap: () {
                                unawaited(
                                  context.router.push(
                                    TransferAmountRoute(
                                      transferMethod:
                                          TransferMethod.wallet.value,
                                      walletAddress: user.customerNumber,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            context.spacingMediumHeight,
            _buildContinueButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: context.paddingNormalHorizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.spacingLowHeight,
          Text(
            LocaleKeys.transfer_method_description.translate,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(TransferMethodState state) {
    return PrimaryElevatedButton(
      text: LocaleKeys.continue_button.translate,
      onPressed: () => onContinuePressed(state),
    );
  }
}
