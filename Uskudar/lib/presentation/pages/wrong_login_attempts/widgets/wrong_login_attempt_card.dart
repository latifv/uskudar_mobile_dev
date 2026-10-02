import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/wrong_password_history.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';

import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class WrongLoginAttemptCard extends StatelessWidget {
  const WrongLoginAttemptCard({
    required this.wrongPasswordHistory,
    super.key,
  });

  final WrongPasswordHistory wrongPasswordHistory;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: context.paddingLowVertical,
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildWarningIcon(context),
                context.spacingNormalWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.wrong_login_attempt.translate,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatDateTime(wrongPasswordHistory.createdDate),
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            context.spacingNormalHeight,
            _buildInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningIcon(BuildContext context) {
    return Container(
      padding: context.paddingLowAll + context.paddingLowHorizontal,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withAlpha(25),
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Icon(
        Icons.warning_outlined,
        size: IconSizeConstants.m,
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.paddingLowAll * 1.25,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurface.withAlpha(25),
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            context,
            LocaleKeys.ip_address.translate,
            wrongPasswordHistory.ipAddress,
            Icons.public,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData iconData,
  ) {
    return Row(
      children: [
        Icon(
          iconData,
          size: IconSizeConstants.n,
          color: context.colorScheme.onSurface.withAlpha(120),
        ),
        context.spacingLowWidth,
        Text(
          '$label: ',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(180),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR');
    return formatter.format(dateTime);
  }
}
