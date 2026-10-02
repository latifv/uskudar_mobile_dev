import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/app_inherited_widget.dart';
import 'package:uskudar_mobile/core/constants/localization_constants.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/border_radius_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

final class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  String _selectedLanguage = LocalizationConstants.tr.languageCode;

  static const _languages = [
    _LanguageItem(
      locale: LocalizationConstants.tr,
      flag: '🇹🇷',
      nativeName: 'Türkçe',
    ),
    _LanguageItem(
      locale: LocalizationConstants.en,
      flag: '🇬🇧',
      nativeName: 'English',
    ),
    _LanguageItem(
      locale: LocalizationConstants.de,
      flag: '🇩🇪',
      nativeName: 'Deutsch',
    ),
    _LanguageItem(
      locale: LocalizationConstants.fr,
      flag: '🇫🇷',
      nativeName: 'Français',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    unawaited(_animationController.forward());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onLanguageSelected(String languageCode) async {
    setState(() => _selectedLanguage = languageCode);
    final locale = Locale(languageCode);
    final appInherited = AppInheritedWidget.of(context);
    if (appInherited != null) {
      await appInherited.updateLocale(locale);
    }
    if (mounted) {
      unawaited(context.setLocale(locale));
    }
  }

  void _onContinue() {
    unawaited(context.router.replace(const OnboardingRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: context.paddingBase,
            child: Column(
              children: [
                context.spacingHighHeight,
                _buildHeader(),
                context.spacingHighHeight,
                Expanded(child: _buildLanguageList()),
                _buildContinueButton(),
                context.spacingNormalHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Icon(
          Icons.translate_rounded,
          size: context.dynamicHeight(0.06),
          color: context.colorScheme.primary,
        ),
        context.spacingNormalHeight,
        Text(
          LocaleKeys.select_your_language.translate,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.select_language_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLanguageList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _languages.length,
      separatorBuilder: (_, __) => context.spacingLowHeight,
      itemBuilder: (_, index) {
        final lang = _languages[index];
        final isSelected = _selectedLanguage == lang.locale.languageCode;
        return _buildLanguageTile(lang, isSelected: isSelected);
      },
    );
  }

  Widget _buildLanguageTile(
    _LanguageItem lang, {
    required bool isSelected,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onLanguageSelected(lang.locale.languageCode),
          borderRadius: context.borderRadiusNormalAll,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: context.paddingNormalAll,
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colorScheme.primary.withValues(alpha: 0.08)
                  : context.colorScheme.surface,
              borderRadius: context.borderRadiusNormalAll,
              border: Border.all(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurface.withValues(alpha: 0.12),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Text(
                  lang.flag,
                  style: TextStyle(fontSize: context.dynamicHeight(0.035)),
                ),
                context.spacingNormalWidth,
                Expanded(
                  child: Text(
                    lang.nativeName,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurface,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return PrimaryElevatedButton(
      onPressed: _onContinue,
      text: LocaleKeys.continue_button.translate,
    );
  }
}

final class _LanguageItem {
  const _LanguageItem({
    required this.locale,
    required this.flag,
    required this.nativeName,
  });

  final Locale locale;
  final String flag;
  final String nativeName;
}
