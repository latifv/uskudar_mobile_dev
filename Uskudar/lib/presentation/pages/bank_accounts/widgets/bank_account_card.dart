import 'package:flutter/material.dart';
import 'package:uskudar_mobile/domain/entities/customer_bank.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class BankAccountCard extends StatelessWidget {
  const BankAccountCard({
    required this.account,
    required this.onDelete,
    required this.onCopyIban,
    this.onTap,
    super.key,
  });

  final CustomerBank account;
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final VoidCallback onCopyIban;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildBankIcon(context),
            context.spacingNormalWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.bankName,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    account.iban,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onCopyIban,
                  icon: const Icon(Icons.copy, size: IconSizeConstants.n),
                  color: context.colorScheme.onSurface,
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: IconSizeConstants.n,
                  ),
                  color: context.colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBankIcon(BuildContext context) {
    return Container(
      padding: context.paddingLowAll + context.paddingLowHorizontal,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Icon(
        Icons.account_balance,
        color: context.colorScheme.primary,
        size: IconSizeConstants.m,
      ),
    );
  }
}
