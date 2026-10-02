import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/enums/time_type.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class AdminStatCard extends StatelessWidget {
  const AdminStatCard({
    required this.title,
    required this.value,
    required this.description,
    required this.onTimeTypeChanged,
    required this.icon,
    this.iconColor,
    super.key,
  });

  final String title;
  final String value;
  final String description;
  final void Function(TimeType) onTimeTypeChanged;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: context.paddingLowAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: iconColor ?? context.colorScheme.primary,
                  size: 32,
                ),
                context.spacingLowWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => _showTimeTypeMenu(context),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeTypeMenu(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (context) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  context,
                  TimeType.day,
                  LocaleKeys.daily.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.month,
                  LocaleKeys.monthly.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.year,
                  LocaleKeys.yearly.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousOneDay,
                  LocaleKeys.one_day_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousTwoDay,
                  LocaleKeys.two_days_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousThreeDay,
                  LocaleKeys.three_days_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousFourDay,
                  LocaleKeys.four_days_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousFiveDay,
                  LocaleKeys.five_days_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousSixDay,
                  LocaleKeys.six_days_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.previousSevenDay,
                  LocaleKeys.seven_days_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.prevOneMonth,
                  LocaleKeys.one_month_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.prevTwoMonth,
                  LocaleKeys.two_months_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.prevThreeMonth,
                  LocaleKeys.three_months_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.prevFourMonth,
                  LocaleKeys.four_months_ago.translate,
                ),
                _buildMenuItem(
                  context,
                  TimeType.prevOneYear,
                  LocaleKeys.one_year_ago.translate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, TimeType timeType, String label) {
    return ListTile(
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        onTimeTypeChanged(timeType);
      },
    );
  }
}
