import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class TransferMethodSelector extends StatelessWidget {
  const TransferMethodSelector({
    required this.onMethodSelected,
    required this.selectedMethod,
    super.key,
  });

  final void Function(TransferMethod) onMethodSelected;
  final TransferMethod selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.transfer_method.translate,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingNormalHeight,
        Row(
          children: [
            _buildMethodItem(
              context,
              TransferMethod.phone,
              LocaleKeys.phone.translate,
              Icons.phone_android,
            ),
            context.spacingLowWidth,
            _buildMethodItem(
              context,
              TransferMethod.wallet,
              LocaleKeys.wallet.translate,
              Icons.account_balance_wallet,
            ),
            context.spacingLowWidth,
            _buildMethodItem(
              context,
              TransferMethod.bankAccount,
              LocaleKeys.bank.translate,
              Icons.account_balance,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMethodItem(
    BuildContext context,
    TransferMethod method,
    String title,
    IconData icon,
  ) {
    final isSelected = selectedMethod == method;

    return Expanded(
      child: GestureDetector(
        onTap: () => onMethodSelected(method),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: context.paddingNormalAll,
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.surface,
            borderRadius: context.borderRadiusLowAll,
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? context.colorScheme.primary.withAlpha(102)
                    : Colors.black.withAlpha(13),
                blurRadius: 8,
                spreadRadius: isSelected ? 1 : 0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: context.paddingLowAll,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withAlpha(52)
                      : context.colorScheme.primary.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? Colors.white
                      : context.colorScheme.primary,
                  size: IconSizeConstants.m,
                ),
              ),
              context.spacingLowHeight,
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Colors.white
                      : context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
