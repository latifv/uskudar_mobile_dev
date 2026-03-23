import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/dasboard/dasboard_screen.dart';
import 'package:payinall/presentation/shared/constants/icon_asset_constants.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    required this.firstName,
    required this.onNotificationPressed,
    required this.onSearchPressed,
    required this.onAvatarPressed,
    this.avatarImage,
    super.key,
  });

  final String firstName;
  final VoidCallback onNotificationPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback onAvatarPressed;
  final String? avatarImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: context.dynamicWidth(0.105),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: context.borderRadiusLowAll * 1.5,
              ),
              child: IconButton(
                onPressed: () {
                  DashboardScreen.openDrawer(context);
                },
                icon: Image.asset(
                  IconAssetsConstants.menu,
                  height: IconSizeConstants.s,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
            context.spacingNormalWidth,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.welcome.translate,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$firstName!',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: context.dynamicHeight(0.05),
          child: Row(
            children: [
              IconButton(
                onPressed: onSearchPressed,
                icon: Icon(
                  Icons.search,
                  size: IconSizeConstants.m,
                  color: context.colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: onNotificationPressed,
                icon: Icon(
                  Icons.notifications_outlined,
                  size: IconSizeConstants.m,
                  color: context.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: onAvatarPressed,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _buildAvatar(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    const avatarSize = IconSizeConstants.l;
    if (avatarImage != null && avatarImage!.isNotEmpty) {
      return CircleAvatar(
        radius: avatarSize / 2,
        backgroundColor: context.colorScheme.primary.withAlpha(50),
        backgroundImage: NetworkImage(avatarImage!),
      );
    }
    return _buildDefaultAvatar(context, avatarSize);
  }

  Widget _buildDefaultAvatar(BuildContext context, double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: context.colorScheme.primary.withAlpha(50),
      child: Text(
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
        style: context.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
