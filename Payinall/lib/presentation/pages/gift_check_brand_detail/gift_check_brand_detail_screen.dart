import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/bloc/gift_check_brand_detail_bloc.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/mixin/gift_check_brand_detail_mixin.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/widgets/brand_detail_header.dart';
import 'package:payinall/presentation/pages/gift_check_brand_detail/widgets/gift_check_coupon_item.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_dialog.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class GiftCheckBrandDetailScreen extends StatefulWidget {
  const GiftCheckBrandDetailScreen({
    required this.brandId,
    super.key,
  });

  final String brandId;

  @override
  State<GiftCheckBrandDetailScreen> createState() =>
      _GiftCheckBrandDetailScreenState();
}

final class _GiftCheckBrandDetailScreenState
    extends State<GiftCheckBrandDetailScreen>
    with GiftCheckBrandDetailMixin {
  @override
  String get brandId => widget.brandId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.brand_detail.translate)),
      body: BlocConsumer<GiftCheckBrandDetailBloc, GiftCheckBrandDetailState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return switch (state.status) {
            GiftCheckBrandDetailStatus.initial ||
            GiftCheckBrandDetailStatus.loading => const Center(
              child: CustomLoading(),
            ),
            GiftCheckBrandDetailStatus.error when state.brandDetail == null =>
              Center(
                child: ErrorTryAgain(
                  message: state.message,
                  onTryAgain: loadBrandDetail,
                ),
              ),
            _ => _buildContent(context, state),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, GiftCheckBrandDetailState state) {
    if (state.brandDetail == null) return const SizedBox.shrink();

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async => loadBrandDetail(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandDetailHeader(brandDetail: state.brandDetail!),
                _buildCouponsSection(context, state),
              ],
            ),
          ),
        ),
        if (state.status == GiftCheckBrandDetailStatus.takingCoupon)
          const ColoredBox(
            color: Colors.black26,
            child: Center(child: CustomLoading()),
          ),
      ],
    );
  }

  Widget _buildCouponsSection(
    BuildContext context,
    GiftCheckBrandDetailState state,
  ) {
    final coupons = [...?state.coupons]
      ..sort((first, second) => first.amount.compareTo(second.amount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.gift_check_choose_buy.translate,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (coupons.isEmpty)
          Padding(
            padding: context.paddingNormalVertical,
            child: Center(
              child: Text(
                LocaleKeys.no_active_coupon.translate,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.03,
            ),
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return GiftCheckCouponItem(
                coupon: coupon,
                cashbackRate: state.brandDetail!.cashbackRate,
                onTakeCoupon: () => _showTakeCouponDialog(
                  couponId: coupon.id,
                  amount: coupon.amount,
                ),
              );
            },
          ),
      ],
    );
  }

  void _showTakeCouponDialog({
    required String couponId,
    required double amount,
  }) {
    unawaited(
      CustomDialog.show(
        context: context,
        title: LocaleKeys.buy_coupon.translate,
        description: LocaleKeys.buy_coupon_confirmation.translateWithNamedArgs({
          'amount': amount.toStringAsFixed(0),
        }),
        icon: Icons.card_giftcard_rounded,
        primaryButtonText: LocaleKeys.purchase.translate,
        onPrimaryButtonPressed: () {
          takeCoupon(couponId: couponId, couponCount: 1);
        },
      ),
    );
  }
}
