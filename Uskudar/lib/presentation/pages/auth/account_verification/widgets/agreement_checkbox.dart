import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_checkbox.dart';

final class AgreementCheckbox extends StatelessWidget {
  const AgreementCheckbox({
    required this.text,
    required this.valueNotifier,
    required this.onTextTap,
    super.key,
  });

  final String text;
  final ValueNotifier<bool> valueNotifier;
  final VoidCallback onTextTap;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: valueNotifier,
            builder: (context, value, child) {
              return CustomCheckbox(
                value: value,
                onChanged: (_) {
                  onTextTap();
                },
              );
            },
          ),
          context.spacingNormalWidth,
          Expanded(
            child: GestureDetector(
              onTap: onTextTap,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: text,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys.register_agreement_suffix.translate,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
