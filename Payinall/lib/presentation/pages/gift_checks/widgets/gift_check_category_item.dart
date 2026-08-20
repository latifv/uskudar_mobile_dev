import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class GiftCheckCategoryItem extends StatelessWidget {
  const GiftCheckCategoryItem({
    required this.category,
    required this.onTap,
    super.key,
  });

  final GiftCheckCategory category;
  final VoidCallback onTap;

  IconData get _categoryIcon {
    final name = category.name.toLowerCase();
    if (name.contains('popüler') || name.contains('popular')) {
      return Icons.star_rounded;
    }
    if (name.contains('giyim') || name.contains('clothing')) {
      return Icons.checkroom_rounded;
    }
    if (name.contains('market')) {
      return Icons.shopping_cart_rounded;
    }
    if (name.contains('yemek') || name.contains('food')) {
      return Icons.restaurant_rounded;
    }
    if (name.contains('teknoloji') || name.contains('tech')) {
      return Icons.devices_rounded;
    }
    return Icons.card_giftcard_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: IntegrationSurface(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            IntegrationIconBox(icon: _categoryIcon, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
