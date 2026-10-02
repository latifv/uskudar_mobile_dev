import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
    this.buttonActive = true,
    this.descriptionStyle,
    this.duration,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;
  final bool buttonActive;
  final Duration? duration;
  final TextStyle? descriptionStyle;
  double get _iconRadius => 48;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: context.borderRadiusLowAll),
      child: Padding(
        padding:
            context.paddingLowVertical +
            context.paddingLowTop +
            context.paddingNormalHorizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (buttonActive)
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => context.router.pop(),
                  child: Icon(
                    Icons.close,
                    size: IconSizeConstants.m,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Column(
              children: [
                _buildIcon(context),
                context.spacingLowHeight,
                _buildTitle(context),
                context.spacingLowHeight,
                _buildDescription(context),
                context.spacingNormalHeight,
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return CircleAvatar(
      radius: _iconRadius,
      backgroundColor: (iconColor ?? context.colorScheme.primary).withAlpha(50),
      child: Icon(
        icon,
        color: iconColor ?? context.colorScheme.primary,
        size: IconSizeConstants.xl,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description,
      style: descriptionStyle ?? context.textTheme.bodySmall,
      textAlign: TextAlign.center,
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    Color? iconColor,
    bool barrierDismissible = true,
    bool buttonActive = true,
    TextStyle? descriptionStyle,
    Duration? duration,
  }) async {
    BuildContext? dialogContext;

    final result = showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dContext) {
        dialogContext = dContext;
        return InfoDialog(
          title: title,
          description: description,
          icon: icon,
          iconColor: iconColor,
          descriptionStyle: descriptionStyle,
          buttonActive: buttonActive,
          duration: duration,
        );
      },
    );

    if (!buttonActive && duration != null) {
      Timer(duration, () {
        if (dialogContext?.mounted ?? false) {
          Navigator.of(dialogContext!).pop();
        }
      });
    }

    return result;
  }
}
