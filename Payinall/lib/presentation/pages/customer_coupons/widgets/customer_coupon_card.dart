import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payinall/domain/entities/customer_coupon.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

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
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                coupon.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
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
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(28),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${coupon.cashbackAmount.toStringAsFixed(0)} ₺',
                style: context.textTheme.labelSmall?.copyWith(
                  color: Colors.green.shade700,
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
        color: context.colorScheme.surfaceContainerHighest,
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
            color: context.colorScheme.outlineVariant,
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
            icon: Icon(
              Icons.copy_rounded,
              size: 20,
              color: context.colorScheme.primary,
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
    Clipboard.setData(ClipboardData(text: '${coupon.code} - ${coupon.pin}'));
    ToastComponent.showSuccessToast(
      context: context,
      message: LocaleKeys.code_copied.translate,
    );
  }
}
