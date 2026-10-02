import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/transaction_history/enum/transaction_filter.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class TransactionFilterTabs extends StatelessWidget {
  const TransactionFilterTabs({
    required this.selectedFilter,
    required this.onFilterSelected,
    required this.onDateRangePressed,
    this.startDate,
    this.endDate,
    super.key,
  });

  final TransactionFilter selectedFilter;
  final void Function(TransactionFilter) onFilterSelected;
  final VoidCallback onDateRangePressed;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: context.paddingLowVertical,
          decoration: BoxDecoration(
            color: context.colorScheme.surface.withValues(alpha: 0.3),
            borderRadius: context.borderRadiusLowAll,
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildFilterTab(
                  context,
                  filter: TransactionFilter.all,
                  label: TransactionFilter.all.label,
                ),
              ),
              Expanded(
                child: _buildFilterTab(
                  context,
                  filter: TransactionFilter.incoming,
                  label: TransactionFilter.incoming.label,
                ),
              ),
              Expanded(
                child: _buildFilterTab(
                  context,
                  filter: TransactionFilter.outgoing,
                  label: TransactionFilter.outgoing.label,
                ),
              ),
            ],
          ),
        ),
        _buildDateRangeButton(context),
      ],
    );
  }

  Widget _buildFilterTab(
    BuildContext context, {
    required TransactionFilter filter,
    required String label,
  }) {
    final isSelected = selectedFilter == filter;

    return GestureDetector(
      onTap: () => onFilterSelected(filter),
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: context.paddingLowVertical,
        decoration: BoxDecoration(
          color: isSelected ? context.colorScheme.surface : Colors.transparent,
          borderRadius: context.borderRadiusLowAll,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? context.colorScheme.onSurface
                : context.colorScheme.onSurface.withAlpha(150),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeButton(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final dateRangeText = startDate != null && endDate != null
        ? '${dateFormat.format(startDate!)} - ${dateFormat.format(endDate!)}'
        : LocaleKeys.select_date_range.translate;

    return Padding(
      padding: context.paddingLowVertical,
      child: GestureDetector(
        onTap: onDateRangePressed,
        child: Container(
          width: double.infinity,
          padding:
              context.paddingHighHorizontal +
              (context.paddingLowVertical * 1.25),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: context.borderRadiusNormalAll,
            border: Border.all(
              color: context.colorScheme.outline.withAlpha(80),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateRangeText,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.calendar_month_outlined,
                size: IconSizeConstants.m,
                color: context.colorScheme.onSurface.withAlpha(180),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
