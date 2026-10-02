import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/frequent_iban.dart';
import 'package:uskudar_mobile/domain/entities/frequently_sent.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';
import 'package:uskudar_mobile/domain/enums/transfer_method.dart';
import 'package:uskudar_mobile/presentation/pages/home/widgets/transaction_list_section.dart';
import 'package:uskudar_mobile/presentation/pages/registered_users/widgets/frequent_iban_card.dart';
import 'package:uskudar_mobile/presentation/pages/registered_users/widgets/frequently_sent_card.dart';
import 'package:uskudar_mobile/presentation/route/app_router.dart';
import 'package:uskudar_mobile/presentation/shared/constants/icon_size_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';

final class HomeTabSection extends StatefulWidget {
  const HomeTabSection({
    required this.transactions,
    required this.frequentIbans,
    required this.frequentlySents,
    super.key,
  });

  final List<Transaction> transactions;
  final List<FrequentIban> frequentIbans;
  final List<FrequentlySent> frequentlySents;

  @override
  State<HomeTabSection> createState() => _HomeTabSectionState();
}

final class _HomeTabSectionState extends State<HomeTabSection> {
  int _currentPage = 0;

  void _onSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! < -200 && _currentPage == 0) {
      if (mounted) setState(() => _currentPage = 1);
    } else if (details.primaryVelocity! > 200 && _currentPage == 1) {
      if (mounted) setState(() => _currentPage = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: _onSwipe,
      child: Column(
        children: [
          _buildTabBar(context),
          context.spacingLowHeight,
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _currentPage == 0
                ? TransactionListSection(
                    key: const ValueKey(0),
                    transactions: widget.transactions,
                  )
                : KeyedSubtree(
                    key: const ValueKey(1),
                    child: _buildFrequentTransfers(context),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTab(
          context,
          title: LocaleKeys.last_transactions.translate,
          index: 0,
        ),
        context.spacingNormalWidth,
        _buildTab(
          context,
          title: LocaleKeys.frequent_transfers.translate,
          index: 1,
        ),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required int index,
  }) {
    final isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () {
        if (mounted) setState(() => _currentPage = index);
      },
      child: Container(
        padding: context.paddingLowHorizontal + context.paddingLowVertical,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? context.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurface.withAlpha(128),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFrequentTransfers(BuildContext context) {
    final isMerchant = getIt<UserInfoManager>().isMerchant;
    if (isMerchant) return _buildFrequentIbansList(context);
    return _buildFrequentlySentsList(context);
  }

  Widget _buildFrequentIbansList(BuildContext context) {
    if (widget.frequentIbans.isEmpty) return _buildEmptyState(context);

    return Column(
      children: widget.frequentIbans.map((iban) {
        return Padding(
          padding: context.paddingLowBottom,
          child: FrequentIbanCard(
            iban: iban,
            showDelete: false,
            onTap: () {
              unawaited(
                context.router.push(
                  TransferAmountRoute(
                    transferMethod: TransferMethod.bankAccount.value,
                    iban: iban.ibanNo,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFrequentlySentsList(BuildContext context) {
    if (widget.frequentlySents.isEmpty) return _buildEmptyState(context);

    return Column(
      children: widget.frequentlySents.map((user) {
        return Padding(
          padding: context.paddingLowBottom,
          child: FrequentlySentCard(
            user: user,
            showDelete: false,
            onTap: () {
              unawaited(
                context.router.push(
                  TransferAmountRoute(
                    transferMethod: TransferMethod.wallet.value,
                    walletAddress: user.customerNumber,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.spacingNormalHeight,
          Icon(
            Icons.people_outline,
            size: IconSizeConstants.xl,
            color: context.colorScheme.onSurface.withAlpha(64),
          ),
          context.spacingNormalHeight,
          Text(
            LocaleKeys.registered_users_empty.translate,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(128),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
