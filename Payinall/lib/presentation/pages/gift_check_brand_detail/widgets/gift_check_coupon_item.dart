import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class GiftCheckCouponItem extends StatelessWidget {
  const GiftCheckCouponItem({
    required this.coupon,
    required this.cashbackRate,
    required this.onTakeCoupon,
    super.key,
  });

  final GiftCheckCoupon coupon;
  final double cashbackRate;
  final VoidCallback onTakeCoupon;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = coupon.stock <= 0;
    final cashbackAmount = coupon.amount * cashbackRate;
    final cashbackText = cashbackAmount == cashbackAmount.roundToDouble()
        ? cashbackAmount.toStringAsFixed(0)
        : cashbackAmount.toStringAsFixed(1);

    return IntegrationSurface(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${coupon.amount.toStringAsFixed(0)} TL',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            LocaleKeys.gift_check_code_value.translate,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isOutOfStock ? null : onTakeCoupon,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(36),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: context.colorScheme.primaryContainer,
                foregroundColor: context.colorScheme.onPrimaryContainer,
              ),
              child: Text(
                isOutOfStock
                    ? LocaleKeys.gift_check_sold_out.translate
                    : LocaleKeys.gift_check_refund.translateWithNamedArgs({
                        'amount': cashbackText,
                      }),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
