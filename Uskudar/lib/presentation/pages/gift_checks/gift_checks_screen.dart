import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/gift_checks/bloc/gift_checks_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/gift_checks/mixin/gift_checks_mixin.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

@RoutePage()
final class GiftChecksScreen extends StatefulWidget {
  const GiftChecksScreen({super.key});

  @override
  State<GiftChecksScreen> createState() => _GiftChecksScreenState();
}

final class _GiftChecksScreenState extends State<GiftChecksScreen>
    with GiftChecksMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlisverislioColors.background,
      appBar: CustomAppBar(
        title: Text(LocaleKeys.gift_checks.translate),
        actions: [
          IconButton(
            onPressed: navigateToCustomerCoupons,
            icon: const Icon(
              Icons.receipt_long_rounded,
              color: AlisverislioColors.primary,
            ),
            tooltip: LocaleKeys.my_coupons.translate,
          ),
        ],
      ),
      body: BlocBuilder<GiftChecksBloc, GiftChecksState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state.status) {
            GiftChecksStatus.initial ||
            GiftChecksStatus.loading => const Center(child: CustomLoading()),
            GiftChecksStatus.error => Center(
              child: AlisverislioStateView(
                icon: Icons.cloud_off_rounded,
                title: LocaleKeys.category_not_found.translate,
                description:
                    state.message ?? LocaleKeys.general_error.translate,
                actionLabel: LocaleKeys.try_again.translate,
                onAction: loadCategories,
                isError: true,
              ),
            ),
            GiftChecksStatus.loaded => _buildContent(state),
          };
        },
      ),
    );
  }

  Widget _buildContent(GiftChecksState state) {
    if (state.categories?.isEmpty ?? true) {
      return Center(
        child: AlisverislioStateView(
          icon: Icons.card_giftcard_outlined,
          title: LocaleKeys.category_not_found.translate,
          description: LocaleKeys.no_gift_check_category.translate,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => loadCategories(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          const _GiftChecksHero(),
          const SizedBox(height: 22),
          Text(
            LocaleKeys.categories.translate,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AlisverislioColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisExtent: 96,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: state.categories!.length,
            itemBuilder: (context, index) {
              final category = state.categories![index];
              return _GiftCategoryCard(
                categoryName: category.name,
                onTap: () => navigateToCategory(category),
              );
            },
          ),
          const SizedBox(height: 22),
          _CouponsCard(onTap: navigateToCustomerCoupons),
        ],
      ),
    );
  }
}

final class _GiftChecksHero extends StatelessWidget {
  const _GiftChecksHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/img_gift.jpg', fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xE8E7467D), Color(0x18E7467D)],
                  stops: [0, 0.78],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.43,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.gift_checks.translate,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        LocaleKeys.gift_checks_description.translate,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

final class _GiftCategoryCard extends StatelessWidget {
  const _GiftCategoryCard({
    required this.categoryName,
    required this.onTap,
  });

  final String categoryName;
  final VoidCallback onTap;

  IconData get _icon {
    final name = categoryName.toLowerCase();
    if (name.contains('popüler') || name.contains('popular')) {
      return Icons.star_rounded;
    }
    if (name.contains('giyim') || name.contains('clothing')) {
      return Icons.checkroom_rounded;
    }
    if (name.contains('market')) return Icons.shopping_cart_rounded;
    if (name.contains('yemek') || name.contains('food')) {
      return Icons.restaurant_rounded;
    }
    if (name.contains('teknoloji') || name.contains('tech')) {
      return Icons.devices_rounded;
    }
    return Icons.card_giftcard_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlisverislioColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            children: [
              IntegrationIconBox(icon: _icon, size: 46),
              const SizedBox(height: 6),
              Text(
                categoryName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AlisverislioColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _CouponsCard extends StatelessWidget {
  const _CouponsCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFEDF3), Color(0xFFF3EEFF)],
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const IntegrationIconBox(
                  icon: Icons.receipt_long_rounded,
                  size: 52,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.my_coupons.translate,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AlisverislioColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        LocaleKeys.gift_checks_description.translate,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AlisverislioColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AlisverislioColors.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
