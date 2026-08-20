import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payinall/domain/entities/gift_check_brand_detail.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class BrandDetailHeader extends StatelessWidget {
  const BrandDetailHeader({required this.brandDetail, super.key});

  final GiftCheckBrandDetail brandDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBrandHero(context),
        const SizedBox(height: 16),
        if (brandDetail.description.isNotEmpty) ...[
          Text(
            'Detaylar ve Koşullar',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Html(
            data: brandDetail.description,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(
                  context.textTheme.bodySmall?.fontSize ?? 14,
                ),
                lineHeight: const LineHeight(1.35),
                color: context.colorScheme.onSurfaceVariant,
              ),
            },
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildBrandHero(BuildContext context) {
    final kdv = brandDetail.kdvRate * 100;
    return IntegrationSurface(
      child: Row(
        children: [
          IntegrationBrandLogo(imageUrl: brandDetail.logo, size: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brandDetail.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                CashbackBadge(rate: brandDetail.cashbackRate),
                const SizedBox(height: 6),
                Text(
                  'Dijital Kod • KDV %${kdv.toStringAsFixed(kdv == kdv.roundToDouble() ? 0 : 1)}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
