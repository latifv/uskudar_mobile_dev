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
          icon: Icons.arrow_outward_outlined,
          label: LocaleKeys.send.translate,
          onPressed: onSendPressed,
          iconColor: Colors.red,
        ),
        context.spacingHighWidth,
        if (!isMerchant) ...[
          _buildActionButton(
            context,
            icon: Icons.arrow_downward,
            label: LocaleKeys.request.translate,
            onPressed: onRequestPressed,
            iconColor: Colors.green,
          ),
          context.spacingHighWidth,
          _buildActionButton(
            context,
            icon: FontAwesomeIcons.moneyBills,
            label: LocaleKeys.withdraw.translate,
            onPressed: onWithdrawPressed,
            iconColor: Colors.blue.shade700,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color iconColor,
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
            child: Icon(
              icon,
              size: IconSizeConstants.m,
              color: iconColor,
            ),
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
