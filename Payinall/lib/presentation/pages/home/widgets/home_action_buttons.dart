import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class HomeActionButtons extends StatelessWidget {
  const HomeActionButtons({
    required this.onSendPressed,
    required this.onRequestPressed,
    required this.onWithdrawPressed,
    required this.isMerchant,
    super.key,
  });
  final VoidCallback onSendPressed;
  final VoidCallback onRequestPressed;
  final VoidCallback onWithdrawPressed;
  final bool isMerchant;
  double get buttonWidth => 0.29;
  double get buttonHeight => 0.055;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          context,
          icon: const Icon(
            Icons.arrow_outward_outlined,
            size: IconSizeConstants.m,
            color: Colors.red,
          ),
          label: LocaleKeys.send.translate,
          onPressed: onSendPressed,
        ),
        context.spacingHighWidth,
        if (!isMerchant) ...[
          _buildActionButton(
            context,
            icon: const Icon(
              Icons.arrow_downward,
              size: IconSizeConstants.m,
              color: Colors.green,
            ),
            label: LocaleKeys.request.translate,
            onPressed: onRequestPressed,
          ),
          context.spacingHighWidth,
          _buildActionButton(
            context,
            icon: const FaIcon(
              FontAwesomeIcons.moneyBills,
              size: IconSizeConstants.m,
              color: Colors.blue,
            ),
            label: LocaleKeys.withdraw.translate,
            onPressed: onWithdrawPressed,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.dynamicWidth(0.15),
            height: context.dynamicHeight(0.065),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: context.borderRadiusNormalAll,
            ),
            child: icon,
          ),
          context.spacingLowHeight,
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
