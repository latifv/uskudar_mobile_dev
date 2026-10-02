import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brands/bloc/gift_check_brands_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brands/mixin/gift_check_brands_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brands/widgets/gift_check_brand_card.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_empty_list.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

@RoutePage()
final class GiftCheckBrandsScreen extends StatefulWidget {
  const GiftCheckBrandsScreen({
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  final String categoryId;
  final String categoryName;

  @override
  State<GiftCheckBrandsScreen> createState() => _GiftCheckBrandsScreenState();
}

final class _GiftCheckBrandsScreenState extends State<GiftCheckBrandsScreen>
    with GiftCheckBrandsMixin {
  @override
  String get categoryId => widget.categoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlisverislioColors.background,
      appBar: CustomAppBar(title: Text(widget.categoryName)),
      body: BlocBuilder<GiftCheckBrandsBloc, GiftCheckBrandsState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state.status) {
            GiftCheckBrandsStatus.initial || GiftCheckBrandsStatus.loading =>
              const Center(child: CustomLoading()),
            GiftCheckBrandsStatus.error => Center(
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: loadBrands,
              ),
            ),
            GiftCheckBrandsStatus.loaded => _buildContent(state),
          };
        },
      ),
    );
  }

  Widget _buildContent(GiftCheckBrandsState state) {
    if (state.brands?.isEmpty ?? true) {
      return Center(
        child: CustomEmptyList(
          iconData: Icons.storefront_outlined,
          title: LocaleKeys.brand_not_found.translate,
          description: LocaleKeys.no_brand_in_category.translate,
        ),
      );
    }

    final showsClothingCard = widget.categoryName.toLowerCase().contains(
      'giyim',
    );

    return RefreshIndicator(
      onRefresh: () async => loadBrands(),
      child: CustomScrollView(
        slivers: [
          if (showsClothingCard)
            SliverToBoxAdapter(child: _buildClothingCardEntry(context)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16,
              showsClothingCard ? 0 : 12,
              16,
              24,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.72,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final brand = state.brands![index];
                return GiftCheckBrandCard(
                  brand: brand,
                  onTap: () => navigateToBrandDetail(brand.id),
                );
              }, childCount: state.brands!.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClothingCardEntry(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Material(
        color: AlisverislioColors.lilac,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.router.push(const MetropolRoute()),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.credit_card_rounded,
                    color: AlisverislioColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.my_clothing_card.translate,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        LocaleKeys.clothing_card_qr_description.translate,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AlisverislioColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AlisverislioColors.primary,
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
