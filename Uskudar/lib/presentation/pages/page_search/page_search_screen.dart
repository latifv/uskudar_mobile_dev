import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/page_search/bloc/page_search_bloc.dart';
import 'package:payinall/presentation/pages/page_search/mixin/page_search_mixin.dart';
import 'package:payinall/presentation/pages/page_search/models/app_page_item.dart';
import 'package:payinall/presentation/shared/constants/icon_size_constants.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';

@RoutePage()
final class PageSearchScreen extends StatefulWidget {
  const PageSearchScreen({super.key});

  @override
  State<PageSearchScreen> createState() => _PageSearchScreenState();
}

final class _PageSearchScreenState extends State<PageSearchScreen>
    with PageSearchMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.page_search.translate),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          context.spacingLowHeight,
          Expanded(
            child: BlocBuilder<PageSearchBloc, PageSearchState>(
              bloc: bloc,
              builder: (_, state) {
                if (state is PageSearchInitial || state is PageSearchLoading) {
                  return const Center(child: CustomLoading());
                }

                if (state is PageSearchLoaded) {
                  return _buildPageList(state);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: context.paddingNormalHorizontal,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: LocaleKeys.search_pages.translate,
          prefixIcon: Icon(
            Icons.search,
            color: context.colorScheme.primary,
            size: IconSizeConstants.m,
          ),
          suffixIcon: BlocBuilder<PageSearchBloc, PageSearchState>(
            bloc: bloc,
            builder: (_, state) {
              if (state is PageSearchLoaded && state.isSearching) {
                return IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: context.colorScheme.onSurface.withAlpha(150),
                    size: IconSizeConstants.m,
                  ),
                  onPressed: clearSearch,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: context.colorScheme.surface,
          contentPadding: context.paddingNormalAll,
          hintStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(100),
          ),
        ),
        style: context.textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildPageList(PageSearchLoaded state) {
    if (state.isEmpty) {
      return CustomEmptyList(
        iconData: Icons.search,
        title: LocaleKeys.search.translate,
        description: LocaleKeys.page_search_description.translate,
      );
    }

    if (state.isSearching && !state.hasResults) {
      return CustomEmptyList(
        iconData: Icons.search_off,
        title: LocaleKeys.no_pages_found.translate,
        description: LocaleKeys.no_pages_found_description.translate,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: context.normalWidth,
        right: context.normalWidth,
        top: context.lowHeight,
        bottom: context.normalHeight,
      ),
      itemCount: state.filteredPages.length,
      itemBuilder: (_, index) {
        return _buildPageItem(state.filteredPages[index]);
      },
    );
  }

  Widget _buildPageItem(AppPageItem page) {
    return Container(
      margin: EdgeInsets.only(bottom: context.lowHeight),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => navigateToPage(page),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: context.paddingNormalAll,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.colorScheme.onSurface.withAlpha(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withAlpha(10),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer.withAlpha(200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconForPage(page.routeName),
                    size: IconSizeConstants.m,
                    color: context.colorScheme.onPrimaryContainer,
                  ),
                ),
                context.spacingNormalWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        page.title,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      context.spacingLowHeight,
                      Text(
                        page.description,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(150),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.colorScheme.onSurface.withAlpha(100),
                  size: IconSizeConstants.m,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForPage(String routeName) {
    switch (routeName) {
      case 'AccountLimitsRoute':
        return Icons.account_balance_wallet_outlined;
      case 'AddBankAccountRoute':
        return Icons.add_business_outlined;
      case 'BankAccountsRoute':
        return Icons.account_balance_outlined;
      case 'BankListRoute':
        return Icons.monetization_on_outlined;
      case 'CampaignsRoute':
        return Icons.local_offer_outlined;
      case 'ChangePasswordRoute':
        return Icons.lock_outline;
      case 'CommissionRatesRoute':
        return Icons.percent_outlined;
      case 'ContactInfoRoute':
        return Icons.contact_mail_outlined;
      case 'FaqRoute':
        return Icons.help_center_outlined;
      case 'NotificationRoute':
        return Icons.notifications_outlined;
      case 'NotificationSettingsRoute':
        return Icons.notifications_active_outlined;
      case 'PendingMoneyRequestsRoute':
        return Icons.pending_actions_outlined;
      case 'QrGenerateRoute':
        return Icons.qr_code_2_outlined;
      case 'QrScanRoute':
        return Icons.qr_code_scanner_outlined;
      case 'RequestMoneyRoute':
        return Icons.request_quote_outlined;
      case 'SecurityChangePhoneRoute':
        return Icons.phone_android_outlined;
      case 'WrongLoginAttemptsRoute':
        return Icons.security_outlined;
      case 'BillPaymentRoute':
        return Icons.receipt_long_outlined;
      case 'TransferMethodRoute':
        return Icons.send_outlined;
      case 'CountrySelectionRoute':
        return Icons.public_outlined;
      default:
        return Icons.pages_outlined;
    }
  }
}
