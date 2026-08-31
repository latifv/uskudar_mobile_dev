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
        const _BrandInfoCard(),
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
    final percentage = brandDetail.cashbackRate * 100;
    final percentageText = percentage == percentage.roundToDouble()
        ? percentage.toStringAsFixed(0)
        : percentage.toStringAsFixed(1).replaceAll('.', ',');
    return IntegrationSurface(
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 148,
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
                            style: context.textTheme.headlineSmall?.copyWith(
                              color: AlisverislioColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            LocaleKeys.gift_check_hero_description
                                .translateWithNamedArgs({'brand': displayName}),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AlisverislioColors.textSecondary,
                              height: 1.25,
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
                      color: AlisverislioColors.cashbackBackground,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '%$percentageText',
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: AlisverislioColors.cashback,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              LocaleKeys.gift_check_cashback_short.translate,
                              textAlign: TextAlign.center,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: AlisverislioColors.cashback,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ColoredBox(
                    color: AlisverislioColors.typeBackground,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        LocaleKeys.gift_check_digital_code.translate,
                        textAlign: TextAlign.center,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: AlisverislioColors.type,
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

final class _BrandInfoCard extends StatelessWidget {
  const _BrandInfoCard();

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _InfoItem(
                icon: Icons.card_giftcard_rounded,
                label: LocaleKeys.gift_check_payment_method.translate,
                value: LocaleKeys.gift_check_payment_method_value.translate,
              ),
            ),
            const _InfoDivider(),
            Expanded(
              child: _InfoItem(
                icon: Icons.money_off_csred_rounded,
                iconColor: AlisverislioColors.type,
                label: LocaleKeys.gift_check_minimum_spend.translate,
                value: LocaleKeys.none.translate,
              ),
            ),
            const _InfoDivider(),
            Expanded(
              child: _InfoItem(
                icon: Icons.schedule_rounded,
                label: LocaleKeys.gift_check_refund_time.translate,
                value: LocaleKeys.gift_check_refund_time_value.translate,
              ),
            ),
            const _InfoDivider(),
            Expanded(
              child: _InfoItem(
                icon: Icons.verified_user_outlined,
                iconColor: AlisverislioColors.cashback,
                label: LocaleKeys.gift_check_validity.translate,
                value: LocaleKeys.gift_check_validity_value.translate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: [
          IntegrationIconBox(icon: icon, color: iconColor, size: 42),
          const SizedBox(height: 9),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: AlisverislioColors.textSecondary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(
              color: AlisverislioColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

final class _InfoDivider extends StatelessWidget {
  const _InfoDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: AlisverislioColors.divider,
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
              _DashedConnector(),
              Expanded(
                child: _Step(
                  number: 2,
                  icon: Icons.shopping_basket_outlined,
                  titleKey: LocaleKeys.gift_check_use_code,
                  descriptionKey: LocaleKeys.gift_check_use_code_description,
                ),
              ),
              _DashedConnector(),
              Expanded(
                child: _Step(
                  number: 3,
                  icon: Icons.currency_lira_rounded,
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
          IntegrationIconBox(icon: icon, size: 52),
          Transform.translate(
            offset: const Offset(0, -5),
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AlisverislioColors.primary,
              child: Text(
                '$number',
                style: context.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
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
              color: AlisverislioColors.textSecondary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

final class _DashedConnector extends StatelessWidget {
  const _DashedConnector();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 25),
      child: SizedBox(
        width: 24,
        height: 2,
        child: CustomPaint(painter: _DashedLinePainter()),
      ),
    );
  }
}

final class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AlisverislioColors.primary.withAlpha(110)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const dash = 4.0;
    const gap = 4.0;
    for (double x = 0; x < size.width; x += dash + gap) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dash).clamp(0, size.width), size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
