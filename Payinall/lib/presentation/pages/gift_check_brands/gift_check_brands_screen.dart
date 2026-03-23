import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/gift_check_brands/bloc/gift_check_brands_bloc.dart';
import 'package:payinall/presentation/pages/gift_check_brands/mixin/gift_check_brands_mixin.dart';
import 'package:payinall/presentation/pages/gift_check_brands/widgets/gift_check_brand_card.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

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
      appBar: CustomAppBar(title: Text(widget.categoryName)),
      body: BlocBuilder<GiftCheckBrandsBloc, GiftCheckBrandsState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state.status) {
            GiftCheckBrandsStatus.initial ||
            GiftCheckBrandsStatus.loading =>
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

    return RefreshIndicator(
      onRefresh: () async => loadBrands(),
      child: GridView.builder(
        padding: context.paddingBaseLow,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: context.lowWidth,
          mainAxisSpacing: context.lowHeight,
        ),
        itemCount: state.brands!.length,
        itemBuilder: (context, index) {
          final brand = state.brands![index];
          return GiftCheckBrandCard(
            brand: brand,
            onTap: () => navigateToBrandDetail(brand.id),
          );
        },
      ),
    );
  }
}
