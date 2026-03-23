import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/constants/image_asset_constants.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
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
      height: context.dynamicHeight(0.22),
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
                  onTap: () =>
                      context.router.push(const GiftChecksRoute()),
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
    final cardWidth = context.dynamicWidth(0.52);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: context.borderRadiusNormalAll,
          border: Border.all(
            color: Colors.grey.shade400,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: context.paddingLowAll + context.paddingLowHorizontal,
                child: ClipRRect(
                  borderRadius: context.borderRadiusNormalAll,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: context.paddingBaseLow,
                child: Center(
                  child: Text(
                    label,
                    style: context.textTheme.titleSmall?.copyWith(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
