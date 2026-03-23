import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

final class BillProductsSection extends StatelessWidget {
  const BillProductsSection({
    required this.searchController,
    required this.filteredProducts,
    required this.isLoading,
    required this.onProductSelected,
    required this.onGoBack,
    super.key,
  });

  final TextEditingController searchController;
  final ValueNotifier<List<BillProduct>> filteredProducts;
  final bool isLoading;
  final void Function(BillProduct) onProductSelected;
  final VoidCallback onGoBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onGoBack,
              icon: const Icon(
                Icons.arrow_back,
                size: IconSizeConstants.m,
              ),
            ),
            context.spacingLowWidth,
            Expanded(
              child: Text(
                LocaleKeys.select_institution.translate,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
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
        if (isLoading)
          Center(
            child: Padding(
              padding: context.paddingHighVertical,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colorScheme.primary,
                ),
              ),
            ),
          )
        else
          ValueListenableBuilder<List<BillProduct>>(
            valueListenable: filteredProducts,
            builder: (context, products, _) {
              if (products.isEmpty) {
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

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (_, _) => context.spacingLowHeight,
                itemBuilder: (context, index) {
                  final product = products[index];
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
                      _ProductCard(
                        product: product,
                        onTap: () => onProductSelected(product),
                      ),
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

final class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  final BillProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: context.colorScheme.secondary.withValues(alpha: 0.05),
        child: Icon(
          _getIconForProduct(product.productName),
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

  IconData _getIconForProduct(String productName) {
    final lowerName = productName.toLowerCase();

    if (lowerName.contains('turkcell')) {
      return Icons.cell_tower;
    } else if (lowerName.contains('vodafone')) {
      return Icons.network_cell;
    } else if (lowerName.contains('telekom') || lowerName.contains('avea')) {
      return Icons.phone;
    } else if (lowerName.contains('tedaş') || lowerName.contains('elektrik')) {
      return Icons.electrical_services;
    } else if (lowerName.contains('igdaş') || lowerName.contains('gaz')) {
      return Icons.local_fire_department;
    } else if (lowerName.contains('iski') || lowerName.contains('su')) {
      return Icons.water_drop;
    } else {
      return Icons.business;
    }
  }
}
