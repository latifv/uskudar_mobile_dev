import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/customer_coupons/bloc/customer_coupons_bloc.dart';
import 'package:payinall/presentation/pages/customer_coupons/mixin/customer_coupons_mixin.dart';
import 'package:payinall/presentation/pages/customer_coupons/widgets/customer_coupon_card.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class CustomerCouponsScreen extends StatefulWidget {
  const CustomerCouponsScreen({super.key});

  @override
  State<CustomerCouponsScreen> createState() => _CustomerCouponsScreenState();
}

final class _CustomerCouponsScreenState extends State<CustomerCouponsScreen>
    with CustomerCouponsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.my_coupons.translate)),
      body: BlocBuilder<CustomerCouponsBloc, CustomerCouponsState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state.status) {
            CustomerCouponsStatus.initial ||
            CustomerCouponsStatus.loading =>
              const Center(child: CustomLoading()),
            CustomerCouponsStatus.error => Center(
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: loadCustomerCoupons,
              ),
            ),
            CustomerCouponsStatus.loaded => _buildContent(state),
          };
        },
      ),
    );
  }

  Widget _buildContent(CustomerCouponsState state) {
    if (state.coupons?.isEmpty ?? true) {
      return Center(
        child: CustomEmptyList(
          iconData: Icons.receipt_long_outlined,
          title: LocaleKeys.coupon_not_found.translate,
          description: LocaleKeys.no_coupon_purchased.translate,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => loadCustomerCoupons(),
      child: ListView.separated(
        padding: context.paddingBaseLow,
        itemCount: state.coupons!.length,
        separatorBuilder: (_, __) => context.spacingLowHeight,
        itemBuilder: (context, index) {
          return CustomerCouponCard(coupon: state.coupons![index]);
        },
      ),
    );
  }
}
