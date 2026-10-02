import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/customer_coupon.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

final class CustomerCouponCard extends StatelessWidget {
  const CustomerCouponCard({required this.coupon, super.key});

  final CustomerCoupon coupon;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 10),
          _buildCodeSection(context),
          const SizedBox(height: 8),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IntegrationBrandLogo(imageUrl: coupon.logo, size: 52),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                coupon.merchantName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AlisverislioColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                coupon.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: AlisverislioColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${coupon.amount.toStringAsFixed(0)} ₺',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AlisverislioColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AlisverislioColors.cashbackBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${coupon.cashbackAmount.toStringAsFixed(0)} ₺',
                style: context.textTheme.labelSmall?.copyWith(
                  color: AlisverislioColors.cashback,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCodeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AlisverislioColors.lilac,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.code.translate,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
                Text(
                  coupon.code,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: AlisverislioColors.divider,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.pin.translate,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                  Text(
                    coupon.pin,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => _copyToClipboard(context),
            icon: const Icon(
              Icons.copy_rounded,
              size: 20,
              color: AlisverislioColors.primary,
            ),
            tooltip: LocaleKeys.copy_code.translate,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final formattedDate = DateFormat('dd.MM.yyyy HH:mm').format(
      coupon.purchaseDate,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formattedDate,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(150),
          ),
        ),
        Text(
          coupon.customerNumber,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    unawaited(
      Clipboard.setData(ClipboardData(text: '${coupon.code} - ${coupon.pin}')),
    );
    ToastComponent.showSuccessToast(
      context: context,
      message: LocaleKeys.code_copied.translate,
    );
  }
}
