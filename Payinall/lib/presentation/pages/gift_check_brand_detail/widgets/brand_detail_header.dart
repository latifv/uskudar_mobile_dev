import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payinall/domain/entities/gift_check_brand_detail.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class BrandDetailHeader extends StatelessWidget {
  const BrandDetailHeader({required this.brandDetail, super.key});

  final GiftCheckBrandDetail brandDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBanner(context),
        context.spacingNormalHeight,
        _buildBrandInfo(context),
        context.spacingNormalHeight,
        _buildRates(context),
        context.spacingNormalHeight,
        if (brandDetail.description.isNotEmpty) ...[
          Html(
            data: brandDetail.description,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(
                  context.textTheme.bodyMedium?.fontSize ?? 14,
                ),
                color: context.colorScheme.onSurface.withAlpha(164),
              ),
            },
          ),
          context.spacingNormalHeight,
        ],
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return ClipRRect(
      borderRadius: context.borderRadiusNormalAll,
      child: ImageNetworkComponent(
        imageUrl: brandDetail.banner,
        fit: BoxFit.cover,
        width: context.screenWidth,
        height: context.dynamicHeight(0.2),
      ),
    );
  }

  Widget _buildBrandInfo(BuildContext context) {
    return Row(
      children: [
        ImageNetworkComponent(
          imageUrl: brandDetail.logo,
          fit: BoxFit.contain,
          width: context.dynamicWidth(0.14),
          height: context.dynamicWidth(0.14),
          borderRadius: context.borderRadiusLowAll,
        ),
        Expanded(
          child: Padding(
            padding: context.paddingNormalHorizontal,
            child: Text(
              brandDetail.name,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRates(BuildContext context) {
    return Row(
      children: [
        _buildRateChip(
          context,
          icon: Icons.percent_rounded,
          label: 'Cashback',
          value: (brandDetail.cashbackRate * 100).toStringAsFixed(0),
          color: context.colorScheme.primary,
        ),
        context.spacingNormalWidth,
        _buildRateChip(
          context,
          icon: Icons.receipt_outlined,
          label: 'KDV',
          value: '%${(brandDetail.kdvRate * 100).toStringAsFixed(0)}',
          color: context.colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildRateChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: context.paddingLowAll,
        decoration: BoxDecoration(
          borderRadius: context.borderRadiusLowAll,
          color: color.withAlpha(30),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            context.spacingLowWidth,
            Text(
              '$value $label',
              style: context.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
