import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/core/generated/locale_keys.g.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transactions/bloc/metropol_transactions_bloc.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transactions/mixin/metropol_transactions_mixin.dart';
import 'package:uskudar_mobile/presentation/pages/metropol_transactions/widgets/metropol_transaction_card.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/padding_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/spacing_extension.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_app_bar.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_empty_list.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';
import 'package:uskudar_mobile/presentation/widgets/error_try_again.dart';

@RoutePage()
final class MetropolTransactionsScreen extends StatefulWidget {
  const MetropolTransactionsScreen({super.key});

  @override
  State<MetropolTransactionsScreen> createState() =>
      _MetropolTransactionsScreenState();
}

final class _MetropolTransactionsScreenState
    extends State<MetropolTransactionsScreen>
    with MetropolTransactionsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.transaction_history.translate),
        actions: [
          IconButton(
            onPressed: onShowDateRangePicker,
            icon: Icon(
              Icons.date_range_rounded,
              color: context.colorScheme.primary,
            ),
            tooltip: LocaleKeys.select_date.translate,
          ),
        ],
      ),
      body: BlocConsumer<MetropolTransactionsBloc, MetropolTransactionsState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return Column(
            children: [
              _buildDateHeader(context),
              Expanded(child: _buildBody(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');
    return Padding(
      padding: context.paddingBaseLow,
      child: InkWell(
        onTap: onShowDateRangePicker,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: context.colorScheme.primary,
            ),
            context.spacingLowWidth,
            Text(
              '${formatter.format(startDate)} - ${formatter.format(endDate)}',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(MetropolTransactionsState state) {
    return switch (state.status) {
      MetropolTransactionsStatus.initial ||
      MetropolTransactionsStatus.loading => const Center(
        child: CustomLoading(),
      ),
      MetropolTransactionsStatus.error when state.transactions == null =>
        Center(
          child: ErrorTryAgain(
            message: state.message,
            onTryAgain: loadTransactions,
          ),
        ),
      _ => _buildContent(state),
    };
  }

  Widget _buildContent(MetropolTransactionsState state) {
    if (state.transactions?.isEmpty ?? true) {
      return Center(
        child: CustomEmptyList(
          iconData: Icons.receipt_long_outlined,
          title: LocaleKeys.transaction_not_found.translate,
          description: LocaleKeys.no_transaction_in_range.translate,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => loadTransactions(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: state.transactions!.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return MetropolTransactionCard(
            transaction: state.transactions![index],
          );
        },
      ),
    );
  }
}
