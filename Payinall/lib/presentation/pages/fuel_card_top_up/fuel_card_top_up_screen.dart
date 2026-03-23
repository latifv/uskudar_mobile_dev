import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/bloc/fuel_card_top_up_bloc.dart';
import 'package:payinall/presentation/pages/fuel_card_top_up/mixin/fuel_card_top_up_mixin.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/double_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/price_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

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
              padding: context.paddingBase,
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
          SizedBox(
            height: context.dynamicHeight(0.2),
            child: _buildIcon(),
          ),
          _buildCardInfo(context, state),
          context.spacingNormalHeight,
          _buildAmountField(context),
          context.spacingMediumHeight,
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Center(
      child: Icon(
        Icons.local_gas_station_rounded,
        size: context.dynamicHeight(0.15),
        color: context.colorScheme.primary,
      ),
    );
  }

  Widget _buildCardInfo(BuildContext context, FuelCardTopUpState state) {
    return Card(
      elevation: 0,
      color: context.colorScheme.primary.withAlpha(15),
      shape: RoundedRectangleBorder(
        borderRadius: context.borderRadiusNormalAll,
      ),
      child: Padding(
        padding: context.paddingNormalAll,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: context.colorScheme.primary.withAlpha(25),
              child: Icon(
                Icons.local_gas_station_rounded,
                color: context.colorScheme.primary,
              ),
            ),
            context.spacingNormalWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${LocaleKeys.card_no.translate}: $cardNo',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (state.status == FuelCardTopUpStatus.loadingBalance)
                    Padding(
                      padding: context.paddingLowTop,
                      child: const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (state.balance != null)
                    Text(
                      '${LocaleKeys.current_balance.translate}: ${state.balance!.toFormattedCurrency()}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
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
