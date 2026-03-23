import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

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
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
        side: BorderSide(color: Colors.grey.shade400),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: context.borderRadiusNormalAll,
        child: Padding(
          padding: context.paddingLowAll,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ImageNetworkComponent(
                  imageUrl: brand.logo,
                  fit: BoxFit.contain,
                  width: context.dynamicWidth(0.2),
                  height: context.dynamicWidth(0.2),
                  borderRadius: context.borderRadiusLowAll,
                ),
              ),
              context.spacingLowHeight,
              Text(
                brand.name,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              context.spacingLowHeight,
              Container(
                padding: context.paddingLowHorizontal,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withAlpha(30),
                  borderRadius: context.borderRadiusLowAll,
                ),
                child: Text(
                  '%${(brand.cashbackRate * 100).toStringAsFixed(0)} Cashback',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
