import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

final class ErrorTryAgain extends StatelessWidget {
  const ErrorTryAgain({required this.onTryAgain, this.message, super.key});

  final String? message;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingNormalAll,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: IconSizeConstants.xxl,
              color: context.colorScheme.error,
            ),
            context.spacingNormalHeight,
            Text(
              LocaleKeys.error.translate,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            context.spacingNormalHeight,
            Text(
              message ?? LocaleKeys.unknown_error.translate,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            context.spacingNormalHeight,
            PrimaryElevatedButton(
              onPressed: onTryAgain,
              text: LocaleKeys.try_again.translate,
            ),
          ],
        ),
      ),
    );
  }
}
