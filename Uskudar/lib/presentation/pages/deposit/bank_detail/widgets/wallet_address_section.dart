import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class WalletAddressSection extends StatelessWidget {
  const WalletAddressSection({
    required this.walletAddress,
    required this.onCopyWalletAddress,
    super.key,
  });

  final String walletAddress;
  final ValueChanged<String> onCopyWalletAddress;

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
        Icon(
          Icons.account_balance_wallet,
          size: IconSizeConstants.xl,
          color: context.colorScheme.primary,
        ),
        context.spacingLowWidth,
        Expanded(
          child: Text(
            LocaleKeys.wallet_address.translate,
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.wallet_address.translate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(153),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                walletAddress,
                style: context.textTheme.displayMedium,
              ),
            ),
            IconButton(
              onPressed: () => onCopyWalletAddress(walletAddress),
              icon: const Icon(Icons.copy_outlined, size: IconSizeConstants.s),
            ),
          ],
        ),
      ],
    );
  }
}
