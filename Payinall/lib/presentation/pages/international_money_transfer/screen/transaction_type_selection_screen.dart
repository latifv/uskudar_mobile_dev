import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/transaction_type.dart';
import 'package:payinall/presentation/pages/international_money_transfer/bloc/country_selection_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';

@RoutePage()
final class TransactionTypeSelectionScreen extends StatefulWidget {
  const TransactionTypeSelectionScreen({
    @PathParam('countryCode') required this.countryCode,
    super.key,
  });

  final String countryCode;

  @override
  State<TransactionTypeSelectionScreen> createState() =>
      _TransactionTypeSelectionScreenState();
}

final class _TransactionTypeSelectionScreenState
    extends State<TransactionTypeSelectionScreen> {
  late final CountrySelectionBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = getIt<CountrySelectionBloc>();
    bloc.add(
      CountrySelectionLoadTransactionTypes(countryCode: widget.countryCode),
    );
  }

  @override
  void dispose() {
    unawaited(bloc.close());
    super.dispose();
  }

  void _blocListener(BuildContext context, CountrySelectionState state) {
    if (state.status == CountrySelectionStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    }
  }

  void _onTransactionTypeSelected(TransactionType transactionType) {
    unawaited(
      context.router.push(
        InternationalMoneyTransferRoute(
          countryCode: widget.countryCode,
          transactionTypeCode: transactionType.transactionTypeCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.select_transaction_type.translate),
      ),
      body: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<CountrySelectionBloc, CountrySelectionState>(
          listener: _blocListener,
          builder: (context, state) {
            if (state.status ==
                CountrySelectionStatus.loadingTransactionTypes) {
              return const Center(child: CustomLoading());
            }

            if (state.status == CountrySelectionStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message ?? LocaleKeys.general_error.translate,
                      textAlign: TextAlign.center,
                    ),
                    context.spacingNormalHeight,
                    ElevatedButton(
                      onPressed: () => bloc.add(
                        CountrySelectionLoadTransactionTypes(
                          countryCode: widget.countryCode,
                        ),
                      ),
                      child: Text(LocaleKeys.retry.translate),
                    ),
                  ],
                ),
              );
            }

            final transactionTypes =
                state.countryTransactionType?.transactionTypes ?? [];

            if (transactionTypes.isEmpty) {
              return Center(
                child: Text(LocaleKeys.no_data.translate),
              );
            }

            return SafeArea(
              child: ListView.builder(
                padding: context.paddingNormalAll,
                itemCount: transactionTypes.length,
                itemBuilder: (context, index) {
                  final transactionType = transactionTypes[index];
                  return _buildTransactionTypeTile(
                    context,
                    transactionType,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionTypeTile(
    BuildContext context,
    TransactionType transactionType,
  ) {
    final corporationCount = transactionType.corporationTransactionTypes.length;

    return Card(
      margin: context.paddingNormalBottom,
      child: InkWell(
        onTap: () => _onTransactionTypeSelected(transactionType),
        borderRadius: context.borderRadiusNormalAll,
        child: Padding(
          padding: context.paddingNormalAll,
          child: Row(
            children: [
              Container(
                padding: context.paddingLowAll,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: context.borderRadiusLowAll,
                ),
                child: Icon(
                  _getTransactionTypeIcon(transactionType.transactionTypeCode),
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionType.transactionTypeName,
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    context.spacingLowHeight,
                    Text(
                      '$corporationCount ${LocaleKeys.corporation.translate}',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTransactionTypeIcon(String transactionTypeCode) {
    return switch (transactionTypeCode) {
      '001' => Icons.person,
      '011' => Icons.account_balance,
      '015' => Icons.credit_card,
      _ => Icons.payment,
    };
  }
}
