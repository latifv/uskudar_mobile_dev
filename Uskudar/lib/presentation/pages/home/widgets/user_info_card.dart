import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/surface_elevated_button.dart';

final class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    required this.title,
    required this.description,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.showSecondaryButton = true,
    super.key,
  });

  final String title;
  final String description;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;
  final bool showSecondaryButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.paddingNormalAll,
      decoration: BoxDecoration(
        borderRadius: context.borderRadiusNormalAll,
        border: Border.all(
          color: context.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _buildIconSection(context)),
          context.spacingNormalHeight,
          Center(child: _buildTitle(context)),
          context.spacingLowHeight,
          _buildDescription(context),
          context.spacingNormalHeight,
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildIconSection(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: context.paddingLowAll + context.paddingLowHorizontal,
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: context.paddingLowAll * .5,
            child: Icon(
              Icons.badge_outlined,
              size: IconSizeConstants.xl,
              color: context.colorScheme.primary,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            width: IconSizeConstants.n,
            height: IconSizeConstants.n,
            decoration: BoxDecoration(
              color: context.colorScheme.error,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.priority_high,
              size: IconSizeConstants.s,
              color: context.colorScheme.onError,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: context.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        if (showSecondaryButton) ...[
          Expanded(
            child: SurfaceElevatedButton(
              height: IconSizeConstants.xl,
              onPressed: onSecondaryButtonPressed ?? () {},
              text: LocaleKeys.later.translate,
            ),
          ),
          context.spacingLowWidth,
        ],
        Expanded(
          child: PrimaryElevatedButton(
            height: IconSizeConstants.xl,
            onPressed: onPrimaryButtonPressed,
            text: primaryButtonText,
            padding: context.paddingLowVertical,
          ),
        ),
      ],
    );
  }
}
