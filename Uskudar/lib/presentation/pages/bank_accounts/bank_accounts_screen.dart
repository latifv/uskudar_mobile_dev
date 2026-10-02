import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/presentation/pages/bank_accounts/bloc/bank_accounts_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/bank_accounts/mixin/bank_accounts_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/bank_accounts/widgets/bank_account_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_empty_list.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

@RoutePage()
final class BankAccountsScreen extends StatefulWidget {
  const BankAccountsScreen({super.key});

  @override
  State<BankAccountsScreen> createState() => _BankAccountsScreenState();
}

final class _BankAccountsScreenState extends State<BankAccountsScreen>
    with BankAccountsMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: CustomAppBar(title: Text(LocaleKeys.bank_accounts.translate)),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<BankAccountsBloc, BankAccountsState>(
                builder: (_, state) {
                  if (state is BankAccountsLoading) {
                    return const Center(child: CustomLoading());
                  }
                  if (state is BankAccountsError) {
                    return ErrorTryAgain(
                      message: state.message,
                      onTryAgain: loadBankAccounts,
                    );
                  }
                  if (state is BankAccountsLoaded) {
                    if (state.accounts.isEmpty) {
                      return Container(
                        padding: context.paddingBase,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            Expanded(
                              child: CustomEmptyList(
                                iconData: Icons.account_balance_outlined,
                                title:
                                    LocaleKeys.bank_empty_list_title.translate,
                                description: LocaleKeys
                                    .bank_empty_list_description
                                    .translate,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildContent(state.accounts);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildAddButton(),
            context.spacingNormalHeight,
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<CustomerBank> accounts) {
    return Padding(
      padding: context.paddingBase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          context.spacingLowHeight,
          Expanded(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (_, index) {
                final account = accounts[index];
                return Column(
                  children: [
                    if (index != 0)
                      Divider(
                        color: context.colorScheme.onSurface.withAlpha(50),
                        thickness: 0.5,
                        height: 1,
                      ),
                    context.spacingNormalHeight,
                    BankAccountCard(
                      account: account,
                      onDelete: () => onDeleteAccount(account),
                      onCopyIban: () => onCopyIban(account.iban),
                    ),
                    context.spacingNormalHeight,
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.bank_accounts_header_title.translate,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.bank_accounts_header_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      padding: context.paddingNormalAll,
      child: SurfaceElevatedButton(
        text: LocaleKeys.add_bank_account.translate,
        onPressed: onAddAccount,
      ),
    );
  }
}
