import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/gift_checks/bloc/gift_checks_bloc.dart';
import 'package:payinall/presentation/pages/gift_checks/mixin/gift_checks_mixin.dart';
import 'package:payinall/presentation/pages/gift_checks/widgets/gift_check_category_item.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

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
      appBar: CustomAppBar(
        title: Text(LocaleKeys.gift_checks.translate),
        actions: [
          IconButton(
            onPressed: navigateToCustomerCoupons,
            icon: Icon(
              Icons.receipt_long_rounded,
              color: context.colorScheme.primary,
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
            GiftChecksStatus.loading =>
              const Center(child: CustomLoading()),
            GiftChecksStatus.error => Center(
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: loadCategories,
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
        child: CustomEmptyList(
          iconData: Icons.card_giftcard_outlined,
          title: LocaleKeys.category_not_found.translate,
          description: LocaleKeys.no_gift_check_category.translate,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => loadCategories(),
      child: ListView.separated(
        padding: context.paddingBaseLow,
        itemCount: state.categories!.length,
        separatorBuilder: (_, __) => context.spacingLowHeight,
        itemBuilder: (context, index) {
          final category = state.categories![index];
          return GiftCheckCategoryItem(
            category: category,
            onTap: () => navigateToBrands(category.id, category.name),
          );
        },
      ),
    );
  }
}
