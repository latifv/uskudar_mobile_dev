import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brand_detail/bloc/gift_check_brand_detail_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brand_detail/mixin/gift_check_brand_detail_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brand_detail/widgets/brand_detail_header.dart';
import 'package:uskudar_mobile/presentation/pages/gift_check_brand_detail/widgets/gift_check_coupon_item.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_dialog.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

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
    return BlocConsumer<GiftCheckBrandDetailBloc, GiftCheckBrandDetailState>(
      bloc: bloc,
      listener: blocListener,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AlisverislioColors.background,
          appBar: AppBar(
            backgroundColor: AlisverislioColors.background,
            foregroundColor: AlisverislioColors.textPrimary,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(LocaleKeys.brand_detail.translate),
          ),
          body: switch (state.status) {
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
          },
          bottomNavigationBar: state.brandDetail == null
              ? null
              : _buildStickyCta(state),
        );
      },
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandDetailHeader(brandDetail: state.brandDetail!),
                _buildCouponsSection(context, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyCta(GiftCheckBrandDetailState state) {
    final isProcessing =
        state.status == GiftCheckBrandDetailStatus.takingCoupon;
    final isSuccess = state.status == GiftCheckBrandDetailStatus.couponTaken;
    final hasSelection = state.selectedCouponId != null;
    final isRetry =
        state.status == GiftCheckBrandDetailStatus.error && hasSelection;

    final title = switch ((isProcessing, isSuccess, isRetry, hasSelection)) {
      (true, _, _, _) => LocaleKeys.gift_check_processing.translate,
      (_, true, _, _) => LocaleKeys.gift_check_ready.translate,
      (_, _, true, _) => LocaleKeys.try_again.translate,
      (_, _, _, true) => LocaleKeys.gift_check_purchase_cta.translate,
      _ => LocaleKeys.gift_check_select_coupon.translate,
    };

    return ColoredBox(
      color: AlisverislioColors.background,
      child: AlisverislioStickyCta(
        title: title,
        subtitle: hasSelection
            ? LocaleKeys.gift_check_purchase_subtitle.translate
            : LocaleKeys.gift_check_select_coupon_subtitle.translate,
        isLoading: isProcessing,
        onPressed: isSuccess ? null : () => _handleCtaPressed(state),
      ),
    );
  }

  void _handleCtaPressed(GiftCheckBrandDetailState state) {
    final selectedId = state.selectedCouponId;
    if (selectedId == null) {
      ToastComponent.showBottomToastMessage(
        context: context,
        message: LocaleKeys.gift_check_select_coupon_first.translate,
      );
      return;
    }

    final selectedCoupon = state.coupons
        ?.where(
          (coupon) => coupon.id == selectedId,
        )
        .firstOrNull;
    if (selectedCoupon == null) return;

    _showTakeCouponDialog(
      couponId: selectedCoupon.id,
      amount: selectedCoupon.amount,
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
                isSelected: state.selectedCouponId == coupon.id,
                onSelect: () => selectCoupon(coupon.id),
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
