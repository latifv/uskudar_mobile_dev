import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/domain/entities/gift_check_coupon.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

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

    return Container(
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusNormalAll,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${coupon.amount.toStringAsFixed(0)} ₺',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  context.spacingLowHeight,
                  Text(
                    isOutOfStock
                        ? LocaleKeys.out_of_stock.translate
                        : '${LocaleKeys.stock.translate}: ${coupon.stock}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isOutOfStock
                          ? context.colorScheme.error
                          : context.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            PrimaryElevatedButton(
              onPressed: isOutOfStock ? () {} : onTakeCoupon,
              text: LocaleKeys.purchase.translate,
              width: 120,
              color: isOutOfStock ? Colors.grey : null,
            ),
          ],
        ),
      ),
    );
  }
}
