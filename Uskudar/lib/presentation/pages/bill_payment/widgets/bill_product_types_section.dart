import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/domain/entities/bill_product.dart';
import 'package:uskudar_mobile/domain/entities/bill_product_type.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_text_form_field.dart';

final class BillProductTypesSection extends StatelessWidget {
  const BillProductTypesSection({
    required this.searchController,
    required this.filteredProductTypes,
    required this.filteredCachedProducts,
    required this.onProductTypeSelected,
    required this.onCachedProductSelected,
    super.key,
  });

  final TextEditingController searchController;
  final ValueNotifier<List<BillProductType>> filteredProductTypes;
  final ValueNotifier<List<BillProduct>> filteredCachedProducts;
  final void Function(BillProductType) onProductTypeSelected;
  final void Function(BillProduct) onCachedProductSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.select_bill_type.translate,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingNormalHeight,
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: searchController,
          builder: (context, value, _) {
            return CustomTextFormField(
              controller: searchController,
              hintText: LocaleKeys.search.translate,
              prefixIcon: Icon(
                Icons.search,
                size: IconSizeConstants.m,
                color: context.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: IconSizeConstants.s,
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      onPressed: searchController.clear,
                    )
                  : null,
            );
          },
        ),
        context.spacingNormalHeight,
        ValueListenableBuilder<List<BillProductType>>(
          valueListenable: filteredProductTypes,
          builder: (context, productTypes, _) {
            return ValueListenableBuilder<List<BillProduct>>(
              valueListenable: filteredCachedProducts,
              builder: (context, cachedProducts, _) {
                final hasResults =
                    productTypes.isNotEmpty || cachedProducts.isNotEmpty;

                if (!hasResults) {
                  return Center(
                    child: Padding(
                      padding: context.paddingHighVertical,
                      child: Text(
                        LocaleKeys.no_results_found.translate,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    if (productTypes.isNotEmpty)
                      ...productTypes.asMap().entries.map((entry) {
                        final index = entry.key;
                        final productType = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0)
                              Divider(
                                height: 1,
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            context.spacingLowHeight,
                            _ProductTypeCard(
                              productType: productType,
                              onTap: () => onProductTypeSelected(productType),
                            ),
                          ],
                        );
                      }),
                    if (productTypes.isNotEmpty && cachedProducts.isNotEmpty)
                      Divider(
                        height: 1,
                        color: context.colorScheme.onSurface.withValues(
                          alpha: 0.15,
                        ),
                      ),
                    if (cachedProducts.isNotEmpty)
                      ...cachedProducts.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index > 0 || productTypes.isNotEmpty)
                              context.spacingLowHeight,
                            _CachedProductCard(
                              product: product,
                              onTap: () => onCachedProductSelected(product),
                            ),
                            if (index < cachedProducts.length - 1)
                              Divider(
                                height: 1,
                                color: context.colorScheme.onSurface.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                          ],
                        );
                      }),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

final class _ProductTypeCard extends StatelessWidget {
  const _ProductTypeCard({
    required this.productType,
    required this.onTap,
  });

  final BillProductType productType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.primary.withValues(alpha: 0.05),
        child: Icon(
          _getIconForProductType(productType.productTypeName),
          color: context.colorScheme.primary,
          size: IconSizeConstants.m,
        ),
      ),
      title: Text(
        productType.productTypeName,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: IconSizeConstants.s,
        color: context.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      onTap: onTap,
      contentPadding: context.paddingLowHorizontal,
    );
  }

  IconData _getIconForProductType(String productTypeName) {
    final lowerName = productTypeName.toLowerCase();

    if (lowerName.contains('elektrik')) {
      return Icons.electrical_services;
    } else if (lowerName.contains('su')) {
      return Icons.water_drop;
    } else if (lowerName.contains('doğalgaz') || lowerName.contains('gaz')) {
      return Icons.local_fire_department;
    } else if (lowerName.contains('gsm') || lowerName.contains('telefon')) {
      return Icons.phone_android;
    } else if (lowerName.contains('internet')) {
      return Icons.wifi;
    } else if (lowerName.contains('uydu') || lowerName.contains('tv')) {
      return Icons.tv;
    } else if (lowerName.contains('ticaret')) {
      return Icons.shopping_cart;
    } else if (lowerName.contains('güvenlik') || lowerName.contains('alarm')) {
      return Icons.security;
    } else if (lowerName.contains('jeotermal') ||
        lowerName.contains('isitma')) {
      return Icons.thermostat;
    } else {
      return Icons.receipt_long;
    }
  }
}

final class _CachedProductCard extends StatelessWidget {
  const _CachedProductCard({
    required this.product,
    required this.onTap,
  });

  final BillProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.1),
        child: Icon(
          Icons.receipt_long_outlined,
          color: context.colorScheme.secondary,
          size: IconSizeConstants.m,
        ),
      ),
      title: Text(
        product.productName,
        style: context.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: IconSizeConstants.s,
        color: context.colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      onTap: onTap,
      contentPadding: context.paddingLowHorizontal,
    );
  }
}
