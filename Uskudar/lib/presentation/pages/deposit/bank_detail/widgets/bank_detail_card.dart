import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class BankDetailCard extends StatelessWidget {
  const BankDetailCard({
    required this.bank,
    required this.onCopyIban,
    super.key,
  });

  final AppBank bank;
  final ValueChanged<String> onCopyIban;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.paddingNormalAll,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          context.spacingLowHeight,
          _buildDetails(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (bank.imageUrl.isNotEmpty)
          Image.asset(
            bank.imageUrl,
            width: IconSizeConstants.xl,
            height: IconSizeConstants.xl,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.account_balance,
              size: IconSizeConstants.xl,
              color: context.colorScheme.primary.withAlpha(179),
            ),
          )
        else
          Icon(
            Icons.account_balance,
            size: IconSizeConstants.xl,
            color: context.colorScheme.primary,
          ),
        context.spacingLowWidth,
        Expanded(
          child: Text(
            bank.bankName,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      children: [
        _buildDetailItem(
          context,
          title: LocaleKeys.iban.translate,
          value: bank.iban,
          onCopy: () => onCopyIban(bank.iban),
        ),
        _buildDetailItem(
          context,
          title: LocaleKeys.account_owner.translate,
          value: LocaleKeys.bank_account_owner_company.translate,
          onCopy: () =>
              onCopyIban(LocaleKeys.bank_account_owner_company.translate),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onCopy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(153),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: context.textTheme.displaySmall?.copyWith(),
              ),
            ),
            IconButton(
              onPressed: onCopy,
              icon: const Icon(Icons.copy_outlined, size: IconSizeConstants.s),
            ),
          ],
        ),
      ],
    );
  }
}
