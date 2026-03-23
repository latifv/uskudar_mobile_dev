part of 'bill_payment_bloc.dart';

enum BillPaymentStatus {
  initial,
  loadingProductTypes,
  productTypesLoaded,
  loadingProducts,
  productsLoaded,
  loadingProductQueryDefinition,
  productQueryDefinitionLoaded,
  inquiryLoading,
  inquiryLoaded,
  paymentLoading,
  paymentSuccess,
  error,
}

enum BillPaymentStep {
  productTypes,
  products,
  inquiry,
  payment,
}

final class BillPaymentState extends Equatable {
  const BillPaymentState({
    this.status = BillPaymentStatus.initial,
    this.step = BillPaymentStep.productTypes,
    this.productTypes = const [],
    this.products = const [],
    this.cachedProducts = const [],
    this.productQueryDefinitions = const [],
    this.billInquiries = const [],
    this.selectedProductType,
    this.selectedProduct,
    this.subscriberNo,
    this.message,
  });

  final BillPaymentStatus status;
  final BillPaymentStep step;
  final List<BillProductType> productTypes;
  final List<BillProduct> products;
  final List<BillProduct> cachedProducts;
  final List<BillProductQueryDefinition> productQueryDefinitions;
  final List<BillInquiry> billInquiries;
  final BillProductType? selectedProductType;
  final BillProduct? selectedProduct;
  final String? subscriberNo;
  final String? message;

  BillInquiry? get billInquiry =>
      billInquiries.isNotEmpty ? billInquiries.first : null;

  BillPaymentState copyWith({
    BillPaymentStatus? status,
    BillPaymentStep? step,
    List<BillProductType>? productTypes,
    List<BillProduct>? products,
    List<BillProduct>? cachedProducts,
    List<BillProductQueryDefinition>? productQueryDefinitions,
    List<BillInquiry>? billInquiries,
    BillProductType? selectedProductType,
    BillProduct? selectedProduct,
    String? subscriberNo,
    String? message,
  }) {
    return BillPaymentState(
      status: status ?? this.status,
      step: step ?? this.step,
      productTypes: productTypes ?? this.productTypes,
      products: products ?? this.products,
      cachedProducts: cachedProducts ?? this.cachedProducts,
      productQueryDefinitions:
          productQueryDefinitions ?? this.productQueryDefinitions,
      billInquiries: billInquiries ?? this.billInquiries,
      selectedProductType: selectedProductType ?? this.selectedProductType,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      subscriberNo: subscriberNo ?? this.subscriberNo,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    step,
    productTypes,
    products,
    cachedProducts,
    productQueryDefinitions,
    billInquiries,
    selectedProductType,
    selectedProduct,
    subscriberNo,
    message,
  ];
}
