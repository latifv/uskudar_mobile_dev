import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/bill_payment/bloc/bill_payment_bloc.dart';
import 'package:payinall/presentation/pages/bill_payment/mixin/bill_payment_mixin.dart';
import 'package:payinall/presentation/pages/bill_payment/widgets/bill_payment_section.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';

@RoutePage()
final class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({this.initialProductId, super.key});

  final String? initialProductId;

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

final class _BillPaymentScreenState extends State<BillPaymentScreen>
    with BillPaymentMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(LocaleKeys.bill_payment.translate),
        ),
        body: BlocConsumer<BillPaymentBloc, BillPaymentState>(
          listener: blocListener,
          builder: (context, state) {
            return SafeArea(
              child: Padding(
                padding: context.paddingNormalHorizontal,
                child: _buildBody(state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BillPaymentState state) {
    if (state.status == BillPaymentStatus.loadingProductTypes) {
      return _buildLoading();
    }

    if (state.status == BillPaymentStatus.error) {
      return _buildError(state.message ?? LocaleKeys.unknown_error.translate);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          BillPaymentSection(
            state: state,
            subscriberControllers: subscriberControllers,
            searchProductTypesController: searchProductTypesController,
            searchProductsController: searchProductsController,
            filteredProductTypes: filteredProductTypes,
            filteredProducts: filteredProducts,
            filteredCachedProducts: filteredCachedProducts,
            onProductTypeSelected: onProductTypeSelected,
            onProductSelected: onProductSelected,
            onCachedProductSelected: onCachedProductSelected,
            onBillInquiry: onBillInquiry,
            onBillPayment: onBillPayment,
            onGoBack: onGoBack,
            formatCurrency: formatCurrency,
            formatDate: formatDate,
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: IconSizeConstants.xxl,
            color: context.colorScheme.error,
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.error.translate,
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          context.spacingLowHeight,
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          context.spacingNormalHeight,
          ElevatedButton(
            onPressed: () {
              bloc.add(const BillPaymentLoadProductTypes());
              searchProductTypesController.clear();
              searchProductsController.clear();
            },
            child: Text(LocaleKeys.try_again.translate),
          ),
        ],
      ),
    );
  }
}
