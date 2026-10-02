import 'package:flutter/material.dart';
import 'package:payinall/domain/entities/notification_setting.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class NotificationSettingItem extends StatelessWidget {
  const NotificationSettingItem({
    required this.setting,
    required this.onSelect,
    super.key,
  });
  final NotificationSettingModel setting;
  final void Function(NotificationType) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingLowVertical,
      child: Row(
        children: [
          Container(
            width: context.dynamicHeight(.05),
            height: context.dynamicHeight(.05),
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withAlpha(25),
              borderRadius: context.borderRadiusNormalAll,
            ),
            child: Icon(
              setting.type.icon,
              color: context.colorScheme.primary,
              size: IconSizeConstants.m,
            ),
          ),
          context.spacingMediumWidth,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  setting.type.title,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                context.spacingLowHeight,
                Text(
                  setting.type.description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withAlpha(140),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: setting.isSelected,
            onChanged: (_) => onSelect(setting.type),
            activeColor: context.colorScheme.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
