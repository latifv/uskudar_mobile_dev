import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_text_button.dart';

final class UserIdentity extends StatelessWidget {
  const UserIdentity({
    required this.identifier,
    required this.onPressedForgetMe,
    super.key,
  });

  final String identifier;
  final VoidCallback onPressedForgetMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.paddingNormalAll,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                identifier.length == 10
                    ? Icons.phone_android_outlined
                    : Icons.perm_identity_outlined,
                color: context.colorScheme.primary,
              ),
              context.spacingLowWidth,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    identifier.length == 10
                        ? LocaleKeys.phone_number.translate
                        : LocaleKeys.tc_number.translate,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                  context.spacingLowHeight,
                  Text(
                    identifier,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          _buildForgetMeButton(),
        ],
      ),
    );
  }

  Widget _buildForgetMeButton() {
    return CustomTextButton(
      onPressed: onPressedForgetMe,
      text: LocaleKeys.forget_me.translate,
    );
  }
}
