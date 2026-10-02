import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';
import 'package:uskudar_mobile/presentation/widgets/surface_elevated_button.dart';

final class CustomDialog extends StatelessWidget {
  const CustomDialog({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    this.color,
    this.textColor,
    this.surfaceButtonActive = true,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final bool surfaceButtonActive;
  double get _iconRadius => 48;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: context.borderRadiusLowAll),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(context),
            context.spacingLowHeight,
            _buildTitle(context),
            context.spacingLowHeight,
            _buildDescription(context),
            context.spacingNormalHeight,
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return CircleAvatar(
      radius: _iconRadius,
      backgroundColor: (color ?? context.colorScheme.primary).withAlpha(50),
      child: Icon(
        icon,
        color: color ?? context.colorScheme.primary,
        size: IconSizeConstants.xl,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description,
      style: context.textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        if (surfaceButtonActive)
          Expanded(
            child: SurfaceElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              text: LocaleKeys.cancel.translate,
            ),
          ),
        context.spacingNormalWidth,
        Expanded(
          child: PrimaryElevatedButton(
            color: color,
            onPressed: onPrimaryButtonPressed,
            text: primaryButtonText,
            textColor: textColor,
          ),
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required String primaryButtonText,
    required VoidCallback onPrimaryButtonPressed,
    Color? color,
    bool barrierDismissible = true,
    Color? textColor,
    bool surfaceButtonActive = true,
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CustomDialog(
        title: title,
        description: description,
        icon: icon,
        color: color,
        primaryButtonText: primaryButtonText,
        onPrimaryButtonPressed: () {
          Navigator.of(context).pop(true);
          onPrimaryButtonPressed.call();
        },
        textColor: textColor,
        surfaceButtonActive: surfaceButtonActive,
      ),
    );
  }
}
