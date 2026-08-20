import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/bloc/fuel_card_top_up_bloc.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/mixin/fuel_card_top_up_mixin.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/price_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

@RoutePage()
final class FuelCardTopUpScreen extends StatefulWidget {
  const FuelCardTopUpScreen({
    required this.fuelCardId,
    required this.cardNo,
    super.key,
  });

  final int fuelCardId;
  final String cardNo;

  @override
  State<FuelCardTopUpScreen> createState() => _FuelCardTopUpScreenState();
}

final class _FuelCardTopUpScreenState extends State<FuelCardTopUpScreen>
    with FuelCardTopUpMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.top_up_balance.translate)),
      body: BlocConsumer<FuelCardTopUpBloc, FuelCardTopUpState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          if (state.status == FuelCardTopUpStatus.submitting) {
            return const Center(child: CustomLoading());
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: _buildBody(state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(FuelCardTopUpState state) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardInfo(context, state),
          const SizedBox(height: 12),
          _buildAmountField(context),
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildCardInfo(BuildContext context, FuelCardTopUpState state) {
    return IntegrationSurface(
      backgroundColor: context.colorScheme.primary.withAlpha(12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const IntegrationIconBox(
            icon: Icons.local_gas_station_rounded,
            size: 42,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${LocaleKeys.card_no.translate}: $cardNo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (state.status == FuelCardTopUpStatus.loadingBalance)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: SizedBox.square(
                      dimension: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else if (state.balance != null)
                  Text(
                    '${LocaleKeys.current_balance.translate}: ${state.balance!.toFormattedCurrency()}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return PriceTextFormField(
      priceController: amountController,
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmit,
      text: LocaleKeys.top_up_balance.translate,
    );
  }
}
