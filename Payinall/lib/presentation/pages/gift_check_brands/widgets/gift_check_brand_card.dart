import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class GiftCheckBrandCard extends StatelessWidget {
  const GiftCheckBrandCard({
    required this.brand,
    required this.onTap,
    super.key,
  });

  final GiftCheckBrand brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: IntegrationBrandLogo(imageUrl: brand.logo, size: 72),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            brand.name,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          CashbackBadge(rate: brand.cashbackRate),
        ],
      ),
    );
  }
}
