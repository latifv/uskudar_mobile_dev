import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/pages/commission_rates/bloc/commission_rates_bloc.dart';
import 'package:payinall/presentation/pages/commission_rates/mixin/commission_rates_mixin.dart';
import 'package:payinall/presentation/pages/commission_rates/widgets/commission_rate_panel.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';

@RoutePage()
final class CommissionRatesScreen extends StatefulWidget {
  const CommissionRatesScreen({super.key});

  @override
  State<CommissionRatesScreen> createState() => _CommissionRatesScreenState();
}

final class _CommissionRatesScreenState extends State<CommissionRatesScreen>
    with CommissionRatesMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.commission_rates.translate)),
      body: BlocBuilder<CommissionRatesBloc, CommissionRatesState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.status == CommissionRatesStatus.initial ||
              state.status == CommissionRatesStatus.loading) {
            return const Center(child: CustomLoading());
          }

          if (state.status == CommissionRatesStatus.error) {
            return ErrorTryAgain(message: state.message, onTryAgain: loadData);
          }

          if (state.status == CommissionRatesStatus.loaded) {
            return Padding(
              padding: context.paddingBase,
              child: _buildBody(state),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBody(CommissionRatesState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.spacingNormalHeight,
        Text(
          LocaleKeys.rates.translate,
          style: context.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        context.spacingLowHeight,
        Text(
          LocaleKeys.rates_description.translate,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(164),
          ),
        ),
        context.spacingNormalHeight,
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.commissionRates?.length ?? 0,
            itemBuilder: (context, index) {
              return CommissionRatePanel(
                commissionRate: state.commissionRates![index],
                onExpanded: (index, isExpanded) {
                  bloc.add(
                    CommissionRatesTogglePanel(
                      index: index,
                      isExpanded: isExpanded,
                    ),
                  );
                },
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}
