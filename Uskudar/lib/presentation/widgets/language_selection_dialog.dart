import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/constants/localization_constants.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({
    required this.selectedLanguage,
    required this.onLanguageSelected,
    super.key,
  });

  final String selectedLanguage;
  final void Function(Locale locale) onLanguageSelected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusLowAll,
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(context),
            context.spacingNormalHeight,
            _buildLanguageList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.language,
          color: context.colorScheme.primary,
          size: IconSizeConstants.m,
        ),
        context.spacingLowWidth,
        Text(
          LocaleKeys.language_selection.translate,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageList(BuildContext context) {
    return Column(
      children: [
        _buildLanguageItem(
          context,
          locale: LocalizationConstants.tr,
          title: LocaleKeys.turkish.translate,
          isSelected: selectedLanguage == LocalizationConstants.tr.languageCode,
        ),
        context.spacingLowHeight,
        _buildLanguageItem(
          context,
          locale: LocalizationConstants.en,
          title: LocaleKeys.english.translate,
          isSelected: selectedLanguage == LocalizationConstants.en.languageCode,
        ),
        context.spacingLowHeight,
        _buildLanguageItem(
          context,
          locale: LocalizationConstants.de,
          title: LocaleKeys.german.translate,
          isSelected: selectedLanguage == LocalizationConstants.de.languageCode,
        ),
        context.spacingLowHeight,
        _buildLanguageItem(
          context,
          locale: LocalizationConstants.fr,
          title: LocaleKeys.french.translate,
          isSelected: selectedLanguage == LocalizationConstants.fr.languageCode,
        ),
      ],
    );
  }

  Widget _buildLanguageItem(
    BuildContext context, {
    required Locale locale,
    required String title,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onLanguageSelected(locale);
      },
      borderRadius: context.borderRadiusLowAll,
      child: Container(
        padding: context.paddingNormalAll,
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: context.borderRadiusLowAll,
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurface.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.colorScheme.primary,
                size: IconSizeConstants.m,
              ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String selectedLanguage,
    required void Function(Locale locale) onLanguageSelected,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (context) => LanguageSelectionDialog(
        selectedLanguage: selectedLanguage,
        onLanguageSelected: onLanguageSelected,
      ),
    );
  }
}
