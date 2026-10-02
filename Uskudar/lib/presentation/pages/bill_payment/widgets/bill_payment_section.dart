import 'package:flutter/material.dart';
import 'package:uskudar_mobile/domain/entities/bill_product.dart';
import 'package:uskudar_mobile/domain/entities/bill_product_type.dart';
import 'package:uskudar_mobile/presentation/pages/bill_payment/bloc/bill_payment_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/bill_payment/widgets/bill_inquiry_section.dart';
import 'package:uskudar_mobile/presentation/pages/bill_payment/widgets/bill_payment_confirmation_section.dart';
import 'package:uskudar_mobile/presentation/pages/bill_payment/widgets/bill_product_types_section.dart';
import 'package:uskudar_mobile/presentation/pages/bill_payment/widgets/bill_products_section.dart';

final class BillPaymentSection extends StatelessWidget {
  const BillPaymentSection({
    required this.state,
    required this.subscriberControllers,
    required this.searchProductTypesController,
    required this.searchProductsController,
    required this.filteredProductTypes,
    required this.filteredProducts,
    required this.filteredCachedProducts,
    required this.onProductTypeSelected,
    required this.onProductSelected,
    required this.onCachedProductSelected,
    required this.onBillInquiry,
    required this.onBillPayment,
    required this.onGoBack,
    required this.formatCurrency,
    required this.formatDate,
    super.key,
  });

  final BillPaymentState state;
  final Map<String, TextEditingController> subscriberControllers;
  final TextEditingController searchProductTypesController;
  final TextEditingController searchProductsController;
  final ValueNotifier<List<BillProductType>> filteredProductTypes;
  final ValueNotifier<List<BillProduct>> filteredProducts;
  final ValueNotifier<List<BillProduct>> filteredCachedProducts;
  final void Function(BillProductType) onProductTypeSelected;
  final void Function(BillProduct) onProductSelected;
  final void Function(BillProduct) onCachedProductSelected;
  final Future<void> Function() onBillInquiry;
  final VoidCallback onBillPayment;
  final VoidCallback onGoBack;
  final String Function(double) formatCurrency;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    switch (state.step) {
      case BillPaymentStep.productTypes:
        return BillProductTypesSection(
          searchController: searchProductTypesController,
          filteredProductTypes: filteredProductTypes,
          filteredCachedProducts: filteredCachedProducts,
          onProductTypeSelected: onProductTypeSelected,
          onCachedProductSelected: onCachedProductSelected,
        );

      case BillPaymentStep.products:
        return BillProductsSection(
          searchController: searchProductsController,
          filteredProducts: filteredProducts,
          isLoading: state.status == BillPaymentStatus.loadingProducts,
          onProductSelected: onProductSelected,
          onGoBack: onGoBack,
        );

      case BillPaymentStep.inquiry:
        if (state.selectedProduct == null) {
          return const SizedBox.shrink();
        }
        return BillInquirySection(
          selectedProduct: state.selectedProduct!,
          productQueryDefinitions: state.productQueryDefinitions,
          subscriberControllers: subscriberControllers,
          onInquiry: onBillInquiry,
          onGoBack: onGoBack,
          isLoading:
              state.status == BillPaymentStatus.inquiryLoading ||
              state.status == BillPaymentStatus.loadingProductQueryDefinition,
        );

      case BillPaymentStep.payment:
        if (state.selectedProduct == null || state.billInquiries.isEmpty) {
          return const SizedBox.shrink();
        }
        return BillPaymentConfirmationSection(
          selectedProduct: state.selectedProduct!,
          billInquiry: state.billInquiries.first,
          onPayment: onBillPayment,
          onGoBack: onGoBack,
          isLoading: state.status == BillPaymentStatus.paymentLoading,
          formatCurrency: formatCurrency,
          formatDate: formatDate,
        );
    }
  }
}
