import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/metropol/bloc/metropol_bloc.dart';
import 'package:payinall/presentation/pages/metropol/mixin/metropol_mixin.dart';
import 'package:payinall/presentation/pages/metropol/widgets/metropol_action_buttons.dart';
import 'package:payinall/presentation/pages/metropol/widgets/metropol_balance_card.dart';
import 'package:payinall/presentation/pages/metropol/widgets/metropol_user_info_card.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class MetropolScreen extends StatefulWidget {
  const MetropolScreen({super.key});

  @override
  State<MetropolScreen> createState() => _MetropolScreenState();
}

final class _MetropolScreenState extends State<MetropolScreen>
    with MetropolMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.metropol.translate)),
      body: BlocConsumer<MetropolBloc, MetropolState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return switch (state.status) {
            MetropolStatus.initial || MetropolStatus.loading =>
              const Center(child: CustomLoading()),
            MetropolStatus.error when state.userDetail == null => Center(
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: loadMetropol,
              ),
            ),
            _ => _buildContent(state),
          };
        },
      ),
    );
  }

  Widget _buildContent(MetropolState state) {
    return RefreshIndicator(
      onRefresh: () async => loadMetropol(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: context.paddingBaseLow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.userDetail != null)
              MetropolUserInfoCard(userDetail: state.userDetail!),
            context.spacingNormalHeight,
            if (state.balance != null)
              MetropolBalanceCard(balance: state.balance!),
            context.spacingNormalHeight,
            MetropolActionButtons(
              onMarketTransferPressed: navigateToTransfer,
              onGiftTransferPressed: navigateToGiftTransfer,
              onLocationsPressed: navigateToLocations,
              onTransactionsPressed: navigateToTransactions,
            ),
          ],
        ),
      ),
    );
  }
}
