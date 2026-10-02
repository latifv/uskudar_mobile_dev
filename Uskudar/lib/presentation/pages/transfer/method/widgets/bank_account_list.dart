import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class BankAccountList extends StatelessWidget {
  const BankAccountList({
    required this.bankAccounts,
    required this.selectedBankAccount,
    required this.onBankAccountSelected,
    super.key,
  });

  final List<CustomerBank> bankAccounts;
  final CustomerBank? selectedBankAccount;
  final void Function(CustomerBank) onBankAccountSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.select_bank_account.translate,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingNormalHeight,
        if (bankAccounts.isEmpty)
          _buildEmptyState(context)
        else
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: bankAccounts.length,
            separatorBuilder: (_, _) => context.spacingLowHeight,
            itemBuilder: (context, index) {
              final bankAccount = bankAccounts[index];
              return _buildBankAccountItem(context, bankAccount);
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: context.paddingNormalAll,
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer.withAlpha(26),
        borderRadius: context.borderRadiusLowAll,
        border: Border.all(
          color: context.colorScheme.errorContainer.withAlpha(77),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: IconSizeConstants.l,
              color: context.colorScheme.errorContainer,
            ),
            context.spacingLowHeight,
            Text(
              LocaleKeys.bank_empty_list_title.translate,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankAccountItem(BuildContext context, CustomerBank bankAccount) {
    final isSelected = selectedBankAccount?.iban == bankAccount.iban;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,

        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onSurface.withAlpha(52),
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onBankAccountSelected(bankAccount),
        borderRadius: context.borderRadiusLowAll,
        child: Padding(
          padding: context.paddingNormalAll,
          child: Row(
            children: [
              Icon(
                Icons.account_balance,
                size: IconSizeConstants.m,
                color: isSelected ? Colors.white : context.colorScheme.primary,
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankAccount.bankName,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? context.colorScheme.onSurface
                            : context.colorScheme.onSurface,
                      ),
                    ),
                    context.spacingLowHeight,
                    Text(
                      _formatIban(bankAccount.iban),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withAlpha(179),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatIban(String iban) {
    if (iban.length <= 8) return iban;
    return '${iban.substring(0, 4)} **** **** ${iban.substring(iban.length - 4)}';
  }
}
