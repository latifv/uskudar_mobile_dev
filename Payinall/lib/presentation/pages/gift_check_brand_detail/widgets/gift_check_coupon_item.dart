import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class GiftCheckCouponItem extends StatelessWidget {
  const GiftCheckCouponItem({
    required this.coupon,
    required this.onTakeCoupon,
    super.key,
  });

  final GiftCheckCoupon coupon;
  final VoidCallback onTakeCoupon;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = coupon.stock <= 0;

    return IntegrationSurface(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IntegrationIconBox(icon: Icons.card_giftcard_rounded),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coupon.amount.toStringAsFixed(0)} ₺',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colorScheme.primary,
                  ),
                ),
                Text(
                  isOutOfStock
                      ? LocaleKeys.out_of_stock.translate
                      : '${LocaleKeys.stock.translate}: ${coupon.stock}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isOutOfStock
                        ? context.colorScheme.error
                        : context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: isOutOfStock ? null : onTakeCoupon,
            style: FilledButton.styleFrom(
              minimumSize: const Size(92, 42),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: Text(
              LocaleKeys.purchase.translate,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
