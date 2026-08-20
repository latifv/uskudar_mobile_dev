import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/constants/image_asset_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class FeatureCardsBanner extends StatelessWidget {
  const FeatureCardsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final userInfoManager = getIt<UserInfoManager>();
    if (userInfoManager.isMerchant) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 136,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (context, index) => context.spacingNormalWidth,
        itemBuilder: (context, index) {
          return switch (index) {
            0 => _FeatureCard(
              label: LocaleKeys.gift_checks.translate,
              imagePath: ImageAssetsConstants.gift,
              onTap: () => context.router.push(const GiftChecksRoute()),
            ),
            1 => _FeatureCard(
              label: LocaleKeys.metropol.translate,
              imagePath: ImageAssetsConstants.metropol,
              onTap: () => context.router.push(const MetropolRoute()),
            ),
            2 => _FeatureCard(
              label: LocaleKeys.fuel_cards.translate,
              imagePath: ImageAssetsConstants.fuel,
              onTap: () => context.router.push(const FuelCardsRoute()),
            ),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

final class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.label,
    required this.imagePath,
    required this.onTap,
  });

  final String label;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width - 56) / 2;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Material(
          color: context.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: context.borderRadiusNormalAll,
            side: BorderSide(
              color: context.colorScheme.outlineVariant.withAlpha(120),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 88,
                width: double.infinity,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      label,
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
