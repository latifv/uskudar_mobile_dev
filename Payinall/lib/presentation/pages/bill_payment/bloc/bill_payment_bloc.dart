import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/bill_inquiry.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/domain/entities/bill_product_query_definition.dart';
import 'package:payinall/domain/entities/bill_product_type.dart';
import 'package:payinall/domain/params/bill_inquiry_params.dart';
import 'package:payinall/domain/params/bill_payment_params.dart';
import 'package:payinall/domain/usecases/bill_payment_usecase.dart';
import 'package:payinall/domain/usecases/get_bill_inquiry_usecase.dart';
import 'package:payinall/domain/usecases/get_cache_product_list_usecase.dart';
import 'package:payinall/domain/usecases/get_product_query_definition_usecase.dart';
import 'package:payinall/domain/usecases/get_product_types_usecase.dart';
import 'package:payinall/domain/usecases/get_products_usecase.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'bill_payment_event.dart';
part 'bill_payment_state.dart';

final class BillPaymentBloc extends Bloc<BillPaymentEvent, BillPaymentState> {
  BillPaymentBloc({
    required GetProductTypesUsecase getProductTypesUsecase,
    required GetProductsUsecase getProductsUsecase,
    required GetProductQueryDefinitionUsecase getProductQueryDefinitionUsecase,
    required GetBillInquiryUsecase getBillInquiryUsecase,
    required BillPaymentUsecase billPaymentUsecase,
    required GetCacheProductListUsecase getCacheProductListUsecase,
    required UserInfoManager userInfoManager,
  }) : _getProductTypesUsecase = getProductTypesUsecase,
       _getProductsUsecase = getProductsUsecase,
       _getProductQueryDefinitionUsecase = getProductQueryDefinitionUsecase,
       _getBillInquiryUsecase = getBillInquiryUsecase,
       _billPaymentUsecase = billPaymentUsecase,
       _getCacheProductListUsecase = getCacheProductListUsecase,
       _userInfoManager = userInfoManager,
       super(const BillPaymentState()) {
    on<BillPaymentLoadProductTypes>(_onLoadProductTypes);
    on<BillPaymentSelectProductType>(_onSelectProductType);
    on<BillPaymentLoadProducts>(_onLoadProducts);
    on<BillPaymentSelectProduct>(_onSelectProduct);
    on<BillPaymentSelectProductById>(_onSelectProductById);
    on<BillPaymentLoadProductQueryDefinition>(_onLoadProductQueryDefinition);
    on<BillPaymentInquiry>(_onBillInquiry);
    on<BillPaymentPay>(_onBillPayment);
    on<BillPaymentReset>(_onReset);
    on<BillPaymentGoBack>(_onGoBack);
  }

  final GetProductTypesUsecase _getProductTypesUsecase;
  final GetProductsUsecase _getProductsUsecase;
  final GetProductQueryDefinitionUsecase _getProductQueryDefinitionUsecase;
  final GetBillInquiryUsecase _getBillInquiryUsecase;
  final BillPaymentUsecase _billPaymentUsecase;
  final GetCacheProductListUsecase _getCacheProductListUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onLoadProductTypes(
    BillPaymentLoadProductTypes event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BillPaymentStatus.loadingProductTypes,
        step: BillPaymentStep.productTypes,
      ),
    );

    final productTypesResult = await _getProductTypesUsecase(null);

    if (_userInfoManager.isMerchant) {
      productTypesResult.fold(
        (failure) => emit(
          state.copyWith(
            status: BillPaymentStatus.error,
            message: failure.message,
          ),
        ),
        (productTypes) => emit(
          state.copyWith(
            status: BillPaymentStatus.productTypesLoaded,
            productTypes: productTypes,
            cachedProducts: const [],
          ),
        ),
      );
      return;
    }

    final cacheProductsResult = await _getCacheProductListUsecase();

    productTypesResult.fold(
      (failure) => emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: failure.message,
        ),
      ),
      (productTypes) {
        cacheProductsResult.fold(
          (_) => emit(
            state.copyWith(
              status: BillPaymentStatus.productTypesLoaded,
              productTypes: productTypes,
              cachedProducts: const [],
            ),
          ),
          (cachedProducts) => emit(
            state.copyWith(
              status: BillPaymentStatus.productTypesLoaded,
              productTypes: productTypes,
              cachedProducts: cachedProducts,
            ),
          ),
        );
      },
    );
  }

  void _onSelectProductType(
    BillPaymentSelectProductType event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProductType: event.productType,
      ),
    );
    add(BillPaymentLoadProducts(event.productType.productTypeId));
  }

  Future<void> _onLoadProducts(
    BillPaymentLoadProducts event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BillPaymentStatus.loadingProducts,
        step: BillPaymentStep.products,
      ),
    );

    final result = await _getProductsUsecase(event.productTypeId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: BillPaymentStatus.productsLoaded,
          products: products,
        ),
      ),
    );
  }

  void _onSelectProduct(
    BillPaymentSelectProduct event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(
      state.copyWith(
        selectedProduct: event.product,
        step: BillPaymentStep.inquiry,
      ),
    );
    add(BillPaymentLoadProductQueryDefinition(event.product.productId));
  }

  Future<void> _onSelectProductById(
    BillPaymentSelectProductById event,
    Emitter<BillPaymentState> emit,
  ) async {
    if (_userInfoManager.isMerchant) {
      emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: LocaleKeys.product_not_found.translate,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: BillPaymentStatus.loadingProductTypes,
      ),
    );

    final cacheProductsResult = await _getCacheProductListUsecase();

    cacheProductsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: failure.message,
        ),
      ),
      (cacheProducts) {
        if (cacheProducts.isEmpty) {
          emit(
            state.copyWith(
              status: BillPaymentStatus.error,
              message: LocaleKeys.no_products_available.translate,
            ),
          );
          return;
        }

        BillProduct? product;
        try {
          product = cacheProducts.firstWhere(
            (p) => p.productId == event.productId,
          );
        } on Exception catch (_) {
          emit(
            state.copyWith(
              status: BillPaymentStatus.error,
              message: LocaleKeys.product_not_found.translate,
            ),
          );
          return;
        }

        emit(
          state.copyWith(
            selectedProduct: product,
            step: BillPaymentStep.inquiry,
            status: BillPaymentStatus.inquiryLoaded,
          ),
        );
        add(BillPaymentLoadProductQueryDefinition(product.productId));
      },
    );
  }

  Future<void> _onLoadProductQueryDefinition(
    BillPaymentLoadProductQueryDefinition event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BillPaymentStatus.loadingProductQueryDefinition,
      ),
    );

    final result = await _getProductQueryDefinitionUsecase(event.productId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: failure.message,
        ),
      ),
      (productQueryDefinitions) {
        // Sort by subcriberNumberKeySizeOrder
        final sortedDefinitions = [...productQueryDefinitions]
          ..sort(
            (a, b) => int.parse(
              a.subcriberNumberKeySizeOrder,
            ).compareTo(int.parse(b.subcriberNumberKeySizeOrder)),
          );

        emit(
          state.copyWith(
            status: BillPaymentStatus.productQueryDefinitionLoaded,
            productQueryDefinitions: sortedDefinitions,
          ),
        );
      },
    );
  }

  Future<void> _onBillInquiry(
    BillPaymentInquiry event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BillPaymentStatus.inquiryLoading,
        subscriberNo: event.subscriberNo,
      ),
    );

    final params = BillInquiryParams(
      productId: event.productId,
      subscriberNo: event.subscriberNo,
      subscriberNo2: event.subscriberNo2,
      subscriberNo3: event.subscriberNo3,
    );

    final result = await _getBillInquiryUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: failure.message,
        ),
      ),
      (billInquiries) => emit(
        state.copyWith(
          status: BillPaymentStatus.inquiryLoaded,
          billInquiries: billInquiries,
          step: BillPaymentStep.payment,
        ),
      ),
    );
  }

  Future<void> _onBillPayment(
    BillPaymentPay event,
    Emitter<BillPaymentState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BillPaymentStatus.paymentLoading,
      ),
    );

    final params = BillPaymentParams(
      subscriberName: event.subscriberName,
      transactionQueryId: event.transactionQueryId,
      invoiceAmount: event.invoiceAmount,
    );

    final result = await _billPaymentUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BillPaymentStatus.error,
          message: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: BillPaymentStatus.paymentSuccess,
        ),
      ),
    );
  }

  void _onReset(
    BillPaymentReset event,
    Emitter<BillPaymentState> emit,
  ) {
    emit(const BillPaymentState());
  }

  void _onGoBack(
    BillPaymentGoBack event,
    Emitter<BillPaymentState> emit,
  ) {
    switch (state.step) {
      case BillPaymentStep.products:
        emit(
          state.copyWith(
            step: BillPaymentStep.productTypes,
            selectedProductType: null,
            products: [],
          ),
        );
      case BillPaymentStep.inquiry:
        if (state.selectedProductType == null) {
          emit(
            state.copyWith(
              step: BillPaymentStep.productTypes,
              selectedProduct: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              step: BillPaymentStep.products,
              selectedProduct: null,
            ),
          );
        }
      case BillPaymentStep.payment:
        emit(
          state.copyWith(
            step: BillPaymentStep.inquiry,
            billInquiries: [],
            subscriberNo: null,
            productQueryDefinitions: [],
          ),
        );
      case BillPaymentStep.productTypes:
        break;
    }
  }
}
