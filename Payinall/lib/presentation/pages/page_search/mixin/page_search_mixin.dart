import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/bill_payment/bloc/bill_payment_bloc.dart';
import 'package:payinall/presentation/pages/page_search/bloc/page_search_bloc.dart';
import 'package:payinall/presentation/pages/page_search/models/app_page_item.dart';
import 'package:payinall/presentation/route/app_router.dart';

mixin PageSearchMixin<T extends StatefulWidget> on State<T> {
  late final PageSearchBloc bloc;
  late final TextEditingController searchController;
  late final FocusNode searchFocusNode;

  @override
  void initState() {
    super.initState();
    bloc = getIt<PageSearchBloc>();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();

    loadData();

    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    searchFocusNode.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void loadData() {
    bloc.add(const PageSearchLoadData());
  }

  void _onSearchChanged() {
    bloc.add(PageSearchQueryChanged(query: searchController.text));
  }

  void clearSearch() {
    searchController.clear();
    bloc.add(const PageSearchClearQuery());
  }

  void navigateToPage(AppPageItem page) {
    if (page.isBillProduct && page.productId != null) {
      context.router.popUntilRoot();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tabsRouter = context.router.root.innerRouterOf<TabsRouter>(
          DashboardRoute.name,
        );
        if (tabsRouter != null) {
          tabsRouter.setActiveIndex(2);

          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              final billPaymentBloc = getIt<BillPaymentBloc>()
                ..add(const BillPaymentReset());
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  billPaymentBloc.add(
                    BillPaymentSelectProductById(page.productId!),
                  );
                }
              });
            }
          });
        }
      });
      return;
    }

    switch (page.routeName) {
      case 'AccountLimitsRoute':
        unawaited(context.router.push(const AccountLimitsRoute()));
      case 'AddBankAccountRoute':
        unawaited(context.router.push(const AddBankAccountRoute()));
      case 'BankAccountsRoute':
        unawaited(context.router.push(const BankAccountsRoute()));
      case 'BankListRoute':
        unawaited(context.router.push(const BankListRoute()));
      case 'CampaignsRoute':
        unawaited(context.router.push(const CampaignsRoute()));
      case 'ChangePasswordRoute':
        unawaited(context.router.push(const ChangePasswordRoute()));
      case 'CommissionRatesRoute':
        unawaited(context.router.push(const CommissionRatesRoute()));
      case 'ContactInfoRoute':
        unawaited(context.router.push(const ContactInfoRoute()));
      case 'FaqRoute':
        unawaited(context.router.push(const FaqRoute()));
      case 'NotificationRoute':
        unawaited(context.router.push(const NotificationRoute()));
      case 'NotificationSettingsRoute':
        unawaited(context.router.push(const NotificationSettingsRoute()));
      case 'PendingMoneyRequestsRoute':
        unawaited(context.router.push(const PendingMoneyRequestsRoute()));
      case 'QrGenerateRoute':
        unawaited(context.router.push(const QrGenerateRoute()));
      case 'QrScanRoute':
        unawaited(context.router.push(const QrScanRoute()));
      case 'RequestMoneyRoute':
        unawaited(context.router.push(const RequestMoneyRoute()));
      case 'SecurityChangePhoneRoute':
        unawaited(context.router.push(const SecurityChangePhoneRoute()));
      case 'WrongLoginAttemptsRoute':
        unawaited(context.router.push(const WrongLoginAttemptsRoute()));
      case 'CountrySelectionRoute':
        unawaited(context.router.push(const CountrySelectionRoute()));
      case 'TransferMethodRoute':
        unawaited(context.router.push(TransferMethodRoute()));
    }
  }
}
