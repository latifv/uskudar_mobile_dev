import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/customer_coupons/bloc/customer_coupons_bloc.dart';
import 'package:payinall/presentation/pages/customer_coupons/mixin/customer_coupons_mixin.dart';
import 'package:payinall/presentation/pages/customer_coupons/widgets/customer_coupon_card.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

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
      backgroundColor: AlisverislioColors.background,
      appBar: CustomAppBar(title: Text(LocaleKeys.my_coupons.translate)),
      body: BlocBuilder<CustomerCouponsBloc, CustomerCouponsState>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state.status) {
            CustomerCouponsStatus.initial || CustomerCouponsStatus.loading =>
              const Center(child: CustomLoading()),
            CustomerCouponsStatus.error => _buildErrorState(state),
            CustomerCouponsStatus.loaded => _buildContent(state),
          };
        },
      ),
    );
  }

  Widget _buildContent(CustomerCouponsState state) {
    if (state.coupons?.isEmpty ?? true) {
      return Center(
        child: AlisverislioStateView(
          icon: Icons.confirmation_number_outlined,
          title: LocaleKeys.my_coupons.translate,
          description: LocaleKeys.no_coupon_purchased.translate,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => loadCustomerCoupons(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: state.coupons!.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return CustomerCouponCard(coupon: state.coupons![index]);
        },
      ),
    );
  }

  Widget _buildErrorState(CustomerCouponsState state) {
    if (_isCouponNotFound(state.message)) {
      return Center(
        child: AlisverislioStateView(
          icon: Icons.confirmation_number_outlined,
          title: LocaleKeys.my_coupons.translate,
          description: LocaleKeys.no_coupon_purchased.translate,
        ),
      );
    }

    return Center(
      child: AlisverislioStateView(
        icon: Icons.cloud_off_rounded,
        title: LocaleKeys.general_error.translate,
        description: state.message ?? LocaleKeys.general_error.translate,
        actionLabel: LocaleKeys.try_again.translate,
        onAction: loadCustomerCoupons,
        isError: true,
      ),
    );
  }

  bool _isCouponNotFound(String? message) {
    if (message == null) return false;

    String normalize(String value) =>
        value.toLowerCase().replaceAll(RegExp(r'[\s.!]'), '');

    final normalizedMessage = normalize(message);
    return normalizedMessage ==
            normalize(LocaleKeys.coupon_not_found.translate) ||
        normalizedMessage == 'couponsnotfound';
  }
}
