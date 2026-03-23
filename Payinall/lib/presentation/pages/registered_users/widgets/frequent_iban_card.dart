import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/frequent_iban.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class FrequentIbanCard extends StatelessWidget {
  const FrequentIbanCard({
    required this.iban,
    this.onDelete,
    this.onTap,
    this.showDelete = true,
    super.key,
  });

  final FrequentIban iban;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool showDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onSurface.withAlpha(52),
            blurRadius: 4,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: context.borderRadiusLowAll,
        child: Padding(
          padding: context.paddingNormalAll,
          child: Row(
            children: [
              Container(
                padding: context.paddingNormalAll,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_outlined,
                  color: context.colorScheme.primary,
                  size: IconSizeConstants.n,
                ),
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${iban.firstName} ${iban.lastName}',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context.spacingLowHeight,
                    Text(
                      _formatIban(iban.ibanNo),
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withAlpha(153),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (showDelete)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: context.colorScheme.error,
                    size: IconSizeConstants.n,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatIban(String ibanNo) {
    if (ibanNo.length <= 8) return ibanNo;
    return '${ibanNo.substring(0, 4)} **** **** ${ibanNo.substring(ibanNo.length - 4)}';
  }
}
