import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class CustomEmptyList extends StatelessWidget {
  const CustomEmptyList({
    required this.iconData,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData iconData;
  final String title;
  final String description;

  int get colorAlpha => 130;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: IconSizeConstants.xxl,
            color: context.colorScheme.primary,
          ),
          context.spacingLowHeight,
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          context.spacingLowHeight,
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(colorAlpha),
            ),
          ),
        ],
      ),
    );
  }
}
