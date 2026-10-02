import 'package:flutter/material.dart';
import 'package:payinall/domain/enums/login_type.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class LoginTypeSegmentedButton extends StatelessWidget {
  const LoginTypeSegmentedButton({
    required this.selectedLoginType,
    required this.onSelectionChanged,
    super.key,
  });

  final LoginType selectedLoginType;
  final void Function(LoginType) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(1),
      child: SegmentedButton<LoginType>(
        style: SegmentedButton.styleFrom(
          foregroundColor: context.colorScheme.onSurface.withValues(alpha: 0.7),
          selectedForegroundColor: context.colorScheme.onPrimary,
          backgroundColor: context.colorScheme.surface,
          selectedBackgroundColor: context.colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: context.borderRadiusLowAll,
          ),
          padding: context.paddingLowVertical,
          side: BorderSide(
            color: context.colorScheme.outline.withValues(alpha: 0.2),
          ),
          iconSize: IconSizeConstants.m,
        ),
        segments: [
          ButtonSegment<LoginType>(
            value: LoginType.individual,
            label: Padding(
              padding: context.paddingLowHorizontal,
              child: Text(
                LoginType.individual.title,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: selectedLoginType == LoginType.individual
                      ? Colors.white
                      : context.colorScheme.onSurface,
                ),
              ),
            ),
            icon: Icon(LoginType.individual.icon),
          ),
          ButtonSegment<LoginType>(
            value: LoginType.merchant,
            label: Padding(
              padding: context.paddingLowHorizontal,
              child: Text(
                LoginType.merchant.title,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: selectedLoginType == LoginType.merchant
                      ? Colors.white
                      : context.colorScheme.onSurface,
                ),
              ),
            ),
            icon: Icon(LoginType.merchant.icon),
          ),
        ],
        selected: {selectedLoginType},
        onSelectionChanged: (newSelection) {
          onSelectionChanged(newSelection.first);
        },
      ),
    );
  }
}
