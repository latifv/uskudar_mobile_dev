import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/fuel_provider.dart';
import 'package:payinall/domain/entities/gift_check_brand.dart';
import 'package:payinall/domain/entities/gift_check_category.dart';
import 'package:payinall/domain/usecases/get_gift_check_brands_usecase.dart';
import 'package:payinall/domain/usecases/get_gift_check_categories_usecase.dart';
import 'package:payinall/presentation/pages/fuel_cards/fuel_provider_detail_screen.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class HomeBrandsSection extends StatefulWidget {
  const HomeBrandsSection({super.key});

  @override
  State<HomeBrandsSection> createState() => _HomeBrandsSectionState();
}

final class _HomeBrandsSectionState extends State<HomeBrandsSection> {
  late final Future<List<GiftCheckBrand>> _brands = _loadBrands();

  Future<List<GiftCheckBrand>> _loadBrands() async {
    final categoryResult = await getIt<GetGiftCheckCategoriesUsecase>()();
    var categories = <GiftCheckCategory>[];
    categoryResult.fold((_) {}, (value) => categories = value);

    if (categories.isEmpty) return const [];

    var selectedCategory = categories.first;
    for (final category in categories) {
      final normalizedName = _normalize(category.name);
      if (normalizedName.contains('populer') ||
          normalizedName.contains('popular')) {
        selectedCategory = category;
        break;
      }
    }

    final brandResult = await getIt<GetGiftCheckBrandsUsecase>()(
      selectedCategory.id,
    );
    var brands = <GiftCheckBrand>[];
    brandResult.fold((_) {}, (value) => brands = value);
    return brands;
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ğ', 'g')
        .replaceAll('ç', 'c');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GiftCheckBrand>>(
      future: _brands,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _HomeSectionLoading(cardWidth: 104, cardHeight: 120);
        }

        final brands = snapshot.data ?? const <GiftCheckBrand>[];
        if (brands.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeSectionHeader(
              title: LocaleKeys.home_brands.translate,
              onViewAll: () =>
                  unawaited(context.router.push(const GiftChecksRoute())),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return _HomeBrandCard(
                    brand: brand,
                    onTap: () => unawaited(
                      context.router.push(
                        GiftCheckBrandDetailRoute(brandId: brand.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

final class HomeFuelDiscountsSection extends StatelessWidget {
  const HomeFuelDiscountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeSectionHeader(
          title: LocaleKeys.fuel_discounts.translate,
          onViewAll: () =>
              unawaited(context.router.push(const FuelCardsRoute())),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 108,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: FuelProvider.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final provider = FuelProvider.values[index];
              return _HomeFuelCard(
                provider: provider,
                onTap: () => unawaited(
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => FuelProviderDetailScreen(
                        provider: provider,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

final class _HomeSectionHeader extends StatelessWidget {
  const _HomeSectionHeader({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            minimumSize: const Size(48, 36),
          ),
          child: Text(
            LocaleKeys.view_all.translate,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

final class _HomeBrandCard extends StatelessWidget {
  const _HomeBrandCard({required this.brand, required this.onTap});

  final GiftCheckBrand brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final cashback = NumberFormat.decimalPattern(
      locale,
    ).format(brand.cashbackRate * 100);

    return Semantics(
      button: true,
      label: integrationBrandDisplayName(brand.name),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 104,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 9),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: ImageNetworkComponent(
                  imageUrl: brand.logo,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                '%$cashback',
                maxLines: 1,
                style: context.textTheme.titleSmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                LocaleKeys.gift_check_cashback_short.translate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _HomeFuelCard extends StatelessWidget {
  const _HomeFuelCard({required this.provider, required this.onTap});

  final FuelProvider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 116,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: provider.brandColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.local_gas_station_rounded,
                color: provider.brandColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              provider.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelLarge?.copyWith(
                color: provider.brandColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              LocaleKeys.fuel_card_advantages.translate,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

final class _HomeSectionLoading extends StatelessWidget {
  const _HomeSectionLoading({
    required this.cardWidth,
    required this.cardHeight,
  });

  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 18,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, _) => Container(
              width: cardWidth,
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
