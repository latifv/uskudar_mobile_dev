import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/usecases/get_cache_product_list_usecase.dart';
import 'package:payinall/presentation/pages/page_search/models/app_page_item.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

part 'page_search_event.dart';
part 'page_search_state.dart';

final class PageSearchBloc extends Bloc<PageSearchEvent, PageSearchState> {
  PageSearchBloc({
    required GetCacheProductListUsecase getCacheProductListUsecase,
    required UserInfoManager userInfoManager,
  }) : _getCacheProductListUsecase = getCacheProductListUsecase,
       _userInfoManager = userInfoManager,
       super(const PageSearchInitial()) {
    on<PageSearchLoadData>(_onLoadData);
    on<PageSearchQueryChanged>(_onQueryChanged);
    on<PageSearchClearQuery>(_onClearQuery);
  }

  final GetCacheProductListUsecase _getCacheProductListUsecase;
  List<AppPageItem> _allPages = [];
  final UserInfoManager _userInfoManager;

  Future<void> _onLoadData(
    PageSearchLoadData event,
    Emitter<PageSearchState> emit,
  ) async {
    emit(const PageSearchLoading());

    var pages = _getAllPages();
    if (_userInfoManager.isMerchant) {
      pages = _filterForMerchant(pages);
    }

    if (_userInfoManager.isMerchant) {
      _allPages = pages;
      emit(
        PageSearchLoaded(
          allPages: _allPages,
          filteredPages: const [],
          query: '',
        ),
      );
      return;
    }

    final billProductsResult = await _getCacheProductListUsecase();

    billProductsResult.fold(
      (failure) {
        _allPages = pages;
        emit(
          PageSearchLoaded(
            allPages: _allPages,
            filteredPages: const [],
            query: '',
          ),
        );
      },
      (billProducts) {
        final billProductItems = billProducts.map((product) {
          return AppPageItem(
            routeName: 'BillPaymentRoute',
            title: product.productName,
            description:
                LocaleKeys.page_search_bill_payment_description.translate,
            productId: product.productId,
          );
        }).toList();
        _allPages = [...pages, ...billProductItems];
        emit(
          PageSearchLoaded(
            allPages: _allPages,
            filteredPages: const [],
            query: '',
          ),
        );
      },
    );
  }

  Future<void> _onQueryChanged(
    PageSearchQueryChanged event,
    Emitter<PageSearchState> emit,
  ) async {
    if (state is! PageSearchLoaded) return;

    final query = event.query.toLowerCase().trim();

    if (query.isEmpty) {
      emit(
        PageSearchLoaded(
          allPages: _allPages,
          filteredPages: _allPages,
          query: '',
        ),
      );
      return;
    }

    final filteredPages = _allPages.where((page) {
      return page.title.toLowerCase().contains(query) ||
          page.description.toLowerCase().contains(query);
    }).toList();

    emit(
      PageSearchLoaded(
        allPages: _allPages,
        filteredPages: filteredPages,
        query: query,
      ),
    );
  }

  Future<void> _onClearQuery(
    PageSearchClearQuery event,
    Emitter<PageSearchState> emit,
  ) async {
    if (state is! PageSearchLoaded) return;

    emit(
      PageSearchLoaded(
        allPages: _allPages,
        filteredPages: _allPages,
        query: '',
      ),
    );
  }

  List<AppPageItem> _getAllPages() {
    return [
      AppPageItem(
        routeName: 'AccountLimitsRoute',
        title: LocaleKeys.page_search_account_limits_title.translate,
        description:
            LocaleKeys.page_search_account_limits_description.translate,
      ),
      AppPageItem(
        routeName: 'AddBankAccountRoute',
        title: LocaleKeys.page_search_add_bank_account_title.translate,
        description:
            LocaleKeys.page_search_add_bank_account_description.translate,
      ),
      AppPageItem(
        routeName: 'BankAccountsRoute',
        title: LocaleKeys.page_search_bank_accounts_title.translate,
        description: LocaleKeys.page_search_bank_accounts_description.translate,
      ),
      AppPageItem(
        routeName: 'BankListRoute',
        title: LocaleKeys.page_search_bank_list_title.translate,
        description: LocaleKeys.page_search_bank_list_description.translate,
      ),
      AppPageItem(
        routeName: 'CampaignsRoute',
        title: LocaleKeys.page_search_campaigns_title.translate,
        description: LocaleKeys.page_search_campaigns_description.translate,
      ),
      AppPageItem(
        routeName: 'ChangePasswordRoute',
        title: LocaleKeys.page_search_change_password_title.translate,
        description:
            LocaleKeys.page_search_change_password_description.translate,
      ),
      AppPageItem(
        routeName: 'CommissionRatesRoute',
        title: LocaleKeys.page_search_commission_rates_title.translate,
        description:
            LocaleKeys.page_search_commission_rates_description.translate,
      ),
      AppPageItem(
        routeName: 'ContactInfoRoute',
        title: LocaleKeys.page_search_contact_info_title.translate,
        description: LocaleKeys.page_search_contact_info_description.translate,
      ),
      AppPageItem(
        routeName: 'FaqRoute',
        title: LocaleKeys.page_search_faq_title.translate,
        description: LocaleKeys.page_search_faq_description.translate,
      ),
      AppPageItem(
        routeName: 'NotificationRoute',
        title: LocaleKeys.page_search_notifications_title.translate,
        description: LocaleKeys.page_search_notifications_description.translate,
      ),
      AppPageItem(
        routeName: 'NotificationSettingsRoute',
        title: LocaleKeys.page_search_notification_settings_title.translate,
        description:
            LocaleKeys.page_search_notification_settings_description.translate,
      ),
      AppPageItem(
        routeName: 'PendingMoneyRequestsRoute',
        title: LocaleKeys.page_search_pending_money_requests_title.translate,
        description:
            LocaleKeys.page_search_pending_money_requests_description.translate,
      ),
      AppPageItem(
        routeName: 'QrGenerateRoute',
        title: LocaleKeys.page_search_qr_generate_title.translate,
        description: LocaleKeys.page_search_qr_generate_description.translate,
      ),
      AppPageItem(
        routeName: 'QrScanRoute',
        title: LocaleKeys.page_search_qr_scan_title.translate,
        description: LocaleKeys.page_search_qr_scan_description.translate,
      ),
      AppPageItem(
        routeName: 'RequestMoneyRoute',
        title: LocaleKeys.page_search_request_money_title.translate,
        description: LocaleKeys.page_search_request_money_description.translate,
      ),
      AppPageItem(
        routeName: 'TransferMethodRoute',
        title: LocaleKeys.transfer_money.translate,
        description:
            LocaleKeys.page_search_transfer_method_description.translate,
      ),
      AppPageItem(
        routeName: 'CountrySelectionRoute',
        title:
            LocaleKeys.page_search_international_money_transfer_title.translate,
        description: LocaleKeys
            .page_search_international_money_transfer_description
            .translate,
      ),
      AppPageItem(
        routeName: 'SecurityChangePhoneRoute',
        title: LocaleKeys.page_search_security_change_phone_title.translate,
        description:
            LocaleKeys.page_search_security_change_phone_description.translate,
      ),
      AppPageItem(
        routeName: 'WrongLoginAttemptsRoute',
        title: LocaleKeys.page_search_wrong_login_attempts_title.translate,
        description:
            LocaleKeys.page_search_wrong_login_attempts_description.translate,
      ),
    ];
  }

  List<AppPageItem> _filterForMerchant(List<AppPageItem> pages) {
    const hiddenRoutes = <String>{
      'QrGenerateRoute',
      'QrScanRoute',
      'NotificationSettingsRoute',
      'ChangePasswordRoute',
      'SecurityChangePhoneRoute',
      'RequestMoneyRoute',
      'BillPaymentRoute',
      'BankListRoute',
      'PendingMoneyRequestsRoute',
      'CampaignsRoute',
    };
    return pages.where((p) => !hiddenRoutes.contains(p.routeName)).toList();
  }
}
