import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:payinall/domain/entities/customer_coupon.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CustomerCouponCard extends StatelessWidget {
  const CustomerCouponCard({required this.coupon, super.key});

  final CustomerCoupon coupon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          children: [
            _buildHeader(context),
            context.spacingLowHeight,
            Divider(color: Colors.grey.shade300, thickness: 0.5),
            context.spacingLowHeight,
            _buildCodeSection(context),
            context.spacingLowHeight,
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        ImageNetworkComponent(
          imageUrl: coupon.logo,
          fit: BoxFit.contain,
          width: context.dynamicWidth(0.12),
          height: context.dynamicWidth(0.12),
          borderRadius: context.borderRadiusLowAll,
        ),
        Expanded(
          child: Padding(
            padding: context.paddingNormalHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.merchantName,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                context.spacingLowHeight,
                Text(
                  coupon.fullName,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${coupon.amount.toStringAsFixed(0)} ₺',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.primary,
              ),
            ),
            context.spacingLowHeight,
            Container(
              padding: context.paddingLowHorizontal,
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(40),
                borderRadius: context.borderRadiusLowAll,
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
      padding: context.paddingLowAll,
      decoration: BoxDecoration(
        color: context.colorScheme.primary.withAlpha(15),
        borderRadius: context.borderRadiusLowAll,
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
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: context.dynamicHeight(0.04),
            color: Colors.grey.shade400,
          ),
          Expanded(
            child: Padding(
              padding: context.paddingNormalLeft,
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
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
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
