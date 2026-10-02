import 'package:flutter/material.dart';
import 'package:uskudar_mobile/domain/entities/app_bank.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class BankCard extends StatelessWidget {
  const BankCard({required this.bank, required this.onTap, super.key});

  final AppBank bank;
  final ValueChanged<AppBank> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(bank),
      child: Container(
        margin: context.paddingLowVertical,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: context.borderRadiusLowAll,
          border: Border.all(
            color: context.colorScheme.onSurface.withAlpha(26),
          ),
        ),
        child: Padding(
          padding: context.paddingLowAll,
          child: Row(
            children: [
              Container(
                padding: context.paddingLowAll,
                child: bank.imageUrl.isNotEmpty
                    ? Image.asset(
                        bank.imageUrl,
                        width: IconSizeConstants.xl,
                        height: IconSizeConstants.xl,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.account_balance,
                          size: IconSizeConstants.xl,
                          color: context.colorScheme.primary.withAlpha(
                            179,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.account_balance,
                        size: IconSizeConstants.xl,
                        color: context.colorScheme.primary.withAlpha(179),
                      ),
              ),
              context.spacingLowWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.bankName,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
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
}
