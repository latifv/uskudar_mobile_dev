import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_coupon.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

final class GiftCheckCouponItem extends StatelessWidget {
  const GiftCheckCouponItem({
    required this.coupon,
    required this.cashbackRate,
    required this.onSelect,
    required this.isSelected,
    super.key,
  });

  final GiftCheckCoupon coupon;
  final double cashbackRate;
  final VoidCallback onSelect;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = coupon.stock <= 0;
    final cashbackAmount = coupon.amount * cashbackRate;
    final cashbackText = cashbackAmount == cashbackAmount.roundToDouble()
        ? cashbackAmount.toStringAsFixed(0)
        : cashbackAmount.toStringAsFixed(1);

    return Material(
      color: isSelected ? AlisverislioColors.lilac : AlisverislioColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? AlisverislioColors.primary
              : AlisverislioColors.divider,
          width: isSelected ? 2 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isOutOfStock ? null : onSelect,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${coupon.amount.toStringAsFixed(0)} TL',
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: AlisverislioColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocaleKeys.gift_check_code_value.translate,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AlisverislioColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isOutOfStock
                          ? const Color(0xFFE1E0E3)
                          : AlisverislioColors.cashbackBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isOutOfStock
                          ? LocaleKeys.gift_check_sold_out.translate
                          : LocaleKeys.gift_check_refund.translateWithNamedArgs(
                              {
                                'amount': cashbackText,
                              },
                            ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isOutOfStock
                            ? AlisverislioColors.textSecondary
                            : AlisverislioColors.cashback,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              if (isSelected)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 22,
                    color: AlisverislioColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
