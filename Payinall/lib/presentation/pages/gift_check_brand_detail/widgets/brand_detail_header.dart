import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/gift_check_brand_detail.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class BrandDetailHeader extends StatelessWidget {
  const BrandDetailHeader({required this.brandDetail, super.key});

  final GiftCheckBrandDetail brandDetail;

  @override
  Widget build(BuildContext context) {
    final displayName = integrationBrandDisplayName(brandDetail.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BrandHero(brandDetail: brandDetail, displayName: displayName),
        const SizedBox(height: 14),
        const _HowItWorks(),
        const SizedBox(height: 14),
        _CashierPrompt(displayName: displayName),
        if (brandDetail.description.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Conditions(description: brandDetail.description),
        ],
        const SizedBox(height: 18),
      ],
    );
  }
}

final class _BrandHero extends StatelessWidget {
  const _BrandHero({required this.brandDetail, required this.displayName});

  final GiftCheckBrandDetail brandDetail;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    final percentage = (brandDetail.cashbackRate * 100).round();
    return IntegrationSurface(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 132,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IntegrationBrandLogo(
                      imageUrl: brandDetail.logo,
                      size: 72,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            LocaleKeys.gift_check_digital_code.translate,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: context.colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '%$percentage',
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: context.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              LocaleKeys.gift_check_cashback_short.translate,
                              textAlign: TextAlign.center,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: context.colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        LocaleKeys.gift_check_digital_code.translate,
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.gift_check_how_it_works.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Step(
                  number: 1,
                  icon: Icons.card_giftcard_rounded,
                  titleKey: LocaleKeys.gift_check_choose_code,
                  descriptionKey: LocaleKeys.gift_check_choose_code_description,
                ),
              ),
              Expanded(
                child: _Step(
                  number: 2,
                  icon: Icons.shopping_basket_outlined,
                  titleKey: LocaleKeys.gift_check_use_code,
                  descriptionKey: LocaleKeys.gift_check_use_code_description,
                ),
              ),
              Expanded(
                child: _Step(
                  number: 3,
                  icon: Icons.savings_outlined,
                  titleKey: LocaleKeys.gift_check_earn_cashback,
                  descriptionKey:
                      LocaleKeys.gift_check_earn_cashback_description,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });

  final int number;
  final IconData icon;
  final String titleKey;
  final String descriptionKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          IntegrationIconBox(icon: icon, size: 46),
          Transform.translate(
            offset: const Offset(0, -5),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: context.colorScheme.primary,
              child: Text(
                '$number',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Text(
            titleKey.translate,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: context.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            descriptionKey.translate,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

final class _CashierPrompt extends StatelessWidget {
  const _CashierPrompt({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.gift_check_cashier_title.translate,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleKeys.gift_check_cashier_prompt.translateWithNamedArgs({
                    'brand': displayName,
                  }),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const IntegrationIconBox(
            icon: Icons.storefront_outlined,
            size: 52,
          ),
        ],
      ),
    );
  }
}

final class _Conditions extends StatelessWidget {
  const _Conditions({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.gift_check_details_conditions.translate,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Html(
            data: description,
            style: {
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(
                  context.textTheme.bodySmall?.fontSize ?? 14,
                ),
                lineHeight: const LineHeight(1.4),
                color: context.colorScheme.onSurfaceVariant,
              ),
              'p': Style(margin: Margins.only(bottom: 8)),
            },
          ),
        ],
      ),
    );
  }
}
