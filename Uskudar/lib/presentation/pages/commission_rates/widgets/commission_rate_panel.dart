import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/commission.dart';
import 'package:uskudar_mobile/domain/enums/commission_money_type.dart';
import 'package:uskudar_mobile/presentation/pages/commission_rates/bloc/commission_rates_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class CommissionRatePanel extends StatelessWidget {
  const CommissionRatePanel({
    required this.commissionRate,
    required this.onExpanded,
    required this.index,
    super.key,
  });

  final CommissionViewModel commissionRate;
  final void Function(int, bool) onExpanded;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: context.paddingLowVertical,
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusLowAll,
        border: Border.all(color: context.colorScheme.onSurface.withAlpha(25)),
      ),
      child: ExpansionTile(
        iconColor: context.colorScheme.onSurface,
        initiallyExpanded: commissionRate.isExpanded,
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            onExpanded(index, true);
          }
        },
        title: Text(
          commissionRate.commission.transferOperationTypeName,
          style: context.textTheme.bodyLarge?.copyWith(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: context.borderRadiusLowBottom,
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: context.borderRadiusLowAll,
        ),
        childrenPadding: context.paddingNormalAll,
        children: [
          const Divider(height: 1),
          context.spacingLowHeight,
          _buildRateItem(
            context,
            LocaleKeys.customer_type.translate,
            commissionRate.commission.customerTypeName,
            valueColor: const Color(0xFFFF6B35),
          ),
          ..._buildConditionalRateItems(context, commissionRate.commission),
          if (commissionRate.commission.processPrevMoney > 0 &&
              commissionRate.commission.prevProcessCount > 0) ...[
            const Divider(height: 1),
            Padding(
              padding: context.paddingLowVertical,
              child: Text(
                LocaleKeys.process_prev_info_text.translate,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onSurface.withAlpha(164),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRateItem(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: context.paddingLowVertical,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(164),
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildConditionalRateItems(
    BuildContext context,
    Commission commission,
  ) {
    final commissionMoneyType = CommissionMoneyType.fromValue(
      commission.defaultCommissionMoneyTypeId,
    );

    final items = <Widget>[];

    switch (commissionMoneyType) {
      case CommissionMoneyType.ratio:
        items.add(
          _buildRateItem(
            context,
            LocaleKeys.commission_rate.translate,
            '${commission.defaultAmount}%',
            valueColor: context.colorScheme.primary,
          ),
        );
      case CommissionMoneyType.amount:
        items.add(
          _buildRateItem(
            context,
            LocaleKeys.commission_amount.translate,
            '${commission.defaultAmount}TL',
            valueColor: context.colorScheme.primary,
          ),
        );
    }

    items.add(
      _buildRateItem(
        context,
        LocaleKeys.commission_from.translate,
        commission.commissionFromTypeName,
      ),
    );

    if (commission.processPrevMoney > 0 && commission.prevProcessCount > 0) {
      items.add(const Divider(height: 1));

      final processPrevMoneyType = CommissionMoneyType.fromValue(
        commission.processPrevMoneyTypeId,
      );

      switch (processPrevMoneyType) {
        case CommissionMoneyType.ratio:
          items.add(
            _buildRateItem(
              context,
              LocaleKeys.process_prev_amount.translate,
              '${commission.processPrevMoney}%',
              valueColor: context.colorScheme.primary,
            ),
          );
        case CommissionMoneyType.amount:
          items.add(
            _buildRateItem(
              context,
              LocaleKeys.process_prev_amount.translate,
              '${commission.processPrevMoney}TL',
              valueColor: context.colorScheme.primary,
            ),
          );
      }

      items
        ..add(
          _buildRateItem(
            context,
            LocaleKeys.process_prev_count.translate,
            '${commission.prevProcessCount}',
          ),
        )
        ..add(
          _buildRateItem(
            context,
            LocaleKeys.process_prev_time.translate,
            commission.processPrevTimeTypeName,
          ),
        );
    }

    return items;
  }
}
