import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

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
          padding: context.paddingNormalAll,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: context.colorScheme.primary.withAlpha(40),
                child: Icon(
                  _categoryIcon,
                  color: context.colorScheme.primary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: context.paddingNormalHorizontal,
                  child: Text(
                    category.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colorScheme.onSurface.withAlpha(150),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
