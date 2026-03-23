import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/domain/entities/bill_product_type.dart';
import 'package:payinall/presentation/pages/bill_payment/bill_payment_screen.dart';
import 'package:payinall/presentation/pages/bill_payment/bloc/bill_payment_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/info_dialog.dart';

mixin BillPaymentMixin<T extends StatefulWidget> on State<T> {
  late final BillPaymentBloc bloc;
  late final Map<String, TextEditingController> subscriberControllers;
  late final TextEditingController searchProductTypesController;
  late final TextEditingController searchProductsController;
  late final ValueNotifier<List<BillProductType>> filteredProductTypes;
  late final ValueNotifier<List<BillProduct>> filteredProducts;
  late final ValueNotifier<List<BillProduct>> filteredCachedProducts;

  String? get initialProductId {
    final widget = this.widget;
    if (widget is BillPaymentScreen) {
      return widget.initialProductId;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    bloc = getIt<BillPaymentBloc>();
    subscriberControllers = {};
    searchProductTypesController = TextEditingController();
    searchProductsController = TextEditingController();
    filteredProductTypes = ValueNotifier<List<BillProductType>>([]);
    filteredProducts = ValueNotifier<List<BillProduct>>([]);
    filteredCachedProducts = ValueNotifier<List<BillProduct>>([]);

    searchProductTypesController.addListener(_onSearchProductTypesChanged);
    searchProductsController.addListener(_onSearchProductsChanged);

    if (initialProductId != null) {
      bloc.add(BillPaymentSelectProductById(initialProductId!));
    } else if (bloc.state.status == BillPaymentStatus.initial) {
      bloc.add(const BillPaymentLoadProductTypes());
    }
  }

  @override
  void dispose() {
    _disposeSubscriberControllers();
    searchProductTypesController.dispose();
    searchProductsController.dispose();
    filteredProductTypes.dispose();
    filteredProducts.dispose();
    filteredCachedProducts.dispose();
    super.dispose();
  }

  void _disposeSubscriberControllers() {
    for (final controller in subscriberControllers.values) {
      controller.dispose();
    }
    subscriberControllers.clear();
  }

  void _initializeSubscriberControllers() {
    _disposeSubscriberControllers();
    final definitions = bloc.state.productQueryDefinitions;
    for (final definition in definitions) {
      subscriberControllers[definition.subcriberNumberKeySizeOrder] =
          TextEditingController();
    }
  }

  void _onSearchProductTypesChanged() {
    final query = searchProductTypesController.text.toLowerCase().trim();
    final allProductTypes = bloc.state.productTypes;
    final allCachedProducts = bloc.state.cachedProducts;

    if (query.isEmpty) {
      filteredProductTypes.value = allProductTypes;
      filteredCachedProducts.value = const [];
    } else {
      filteredProductTypes.value = allProductTypes
          .where(
            (productType) =>
                productType.productTypeName.toLowerCase().contains(query),
          )
          .toList();

      filteredCachedProducts.value = allCachedProducts
          .where(
            (product) => product.productName.toLowerCase().contains(query),
          )
          .toList();
    }
  }

  void _onSearchProductsChanged() {
    final query = searchProductsController.text.toLowerCase().trim();
    final allProducts = bloc.state.products;

    if (query.isEmpty) {
      filteredProducts.value = allProducts;
    } else {
      filteredProducts.value = allProducts
          .where(
            (product) => product.productName.toLowerCase().contains(query),
          )
          .toList();
    }
  }

  Future<void> blocListener(_, BillPaymentState state) async {
    if (state.status == BillPaymentStatus.paymentSuccess) {
      _showSuccessDialog();
    } else if (state.status == BillPaymentStatus.productTypesLoaded) {
      filteredProductTypes.value = state.productTypes;
      filteredCachedProducts.value = const [];
      searchProductTypesController.clear();
    } else if (state.status == BillPaymentStatus.productsLoaded) {
      filteredProducts.value = state.products;
      searchProductsController.clear();
    } else if (state.status == BillPaymentStatus.productQueryDefinitionLoaded) {
      _initializeSubscriberControllers();
    }
  }

  void onProductTypeSelected(BillProductType productType) {
    bloc.add(BillPaymentSelectProductType(productType));
  }

  void onProductSelected(BillProduct product) {
    bloc.add(BillPaymentSelectProduct(product));
  }

  void onCachedProductSelected(BillProduct product) {
    bloc.add(BillPaymentSelectProductById(product.productId));
  }

  Future<void> onBillInquiry() async {
    final definitions = bloc.state.productQueryDefinitions;
    if (definitions.isEmpty) {
      ToastComponent.showBottomToastMessage(
        context: context,
        message: LocaleKeys.product_not_selected.translate,
      );
      return;
    }

    // Get subscriber numbers based on order
    String? subscriberNo;
    String? subscriberNo2;
    String? subscriberNo3;

    for (final definition in definitions) {
      final controller =
          subscriberControllers[definition.subcriberNumberKeySizeOrder];
      final value = controller?.text.trim() ?? '';

      if (value.isEmpty && definition.mandatoryParams == '1') {
        ToastComponent.showBottomToastMessage(
          context: context,
          message:
              '${definition.subcriberNumberLabel} ${LocaleKeys.required_field.translate}',
        );
        return;
      }

      final order = int.parse(definition.subcriberNumberKeySizeOrder);
      switch (order) {
        case 1:
          subscriberNo = value;
        case 2:
          subscriberNo2 = value.isEmpty ? null : value;
        case 3:
          subscriberNo3 = value.isEmpty ? null : value;
      }
    }

    if (subscriberNo == null || subscriberNo.isEmpty) {
      ToastComponent.showBottomToastMessage(
        context: context,
        message: LocaleKeys.subscriber_no_required.translate,
      );
      return;
    }

    final selectedProduct = bloc.state.selectedProduct;
    if (selectedProduct == null) {
      ToastComponent.showBottomToastMessage(
        context: context,
        message: LocaleKeys.product_not_selected.translate,
      );
      return;
    }

    bloc.add(
      BillPaymentInquiry(
        productId: selectedProduct.productId,
        subscriberNo: subscriberNo,
        subscriberNo2: subscriberNo2,
        subscriberNo3: subscriberNo3,
      ),
    );
  }

  void onBillPayment() {
    final billInquiry = bloc.state.billInquiry;

    if (billInquiry == null) {
      ToastComponent.showBottomToastMessage(
        context: context,
        message: LocaleKeys.payment_data_incomplete.translate,
      );
      return;
    }

    bloc.add(
      BillPaymentPay(
        subscriberName: billInquiry.subscriberName,
        transactionQueryId: billInquiry.transactionQueryId,
        invoiceAmount: billInquiry.invoiceAmount,
      ),
    );
  }

  void onGoBack() {
    _clearSubscriberControllers();
    bloc.add(const BillPaymentGoBack());
  }

  void onReset() {
    _clearSubscriberControllers();
    bloc.add(const BillPaymentReset());
  }

  void _clearSubscriberControllers() {
    for (final controller in subscriberControllers.values) {
      controller.clear();
    }
  }

  void navigateBack() {
    context.router.pop();
  }

  void _showSuccessDialog() {
    unawaited(
      InfoDialog.show(
        context: context,
        title: LocaleKeys.success.translate,
        description: LocaleKeys.bill_payment_success.translate,
        icon: Icons.check_circle_outline,
        iconColor: context.colorScheme.primary,
        barrierDismissible: false,
        buttonActive: false,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        onReset();
        bloc.add(const BillPaymentLoadProductTypes());
      }
    });
  }

  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ₺';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
