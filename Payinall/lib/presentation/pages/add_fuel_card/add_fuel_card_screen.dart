import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/add_fuel_card/bloc/add_fuel_card_bloc.dart';
import 'package:payinall/presentation/pages/add_fuel_card/mixin/add_fuel_card_mixin.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class AddFuelCardScreen extends StatefulWidget {
  const AddFuelCardScreen({super.key});

  @override
  State<AddFuelCardScreen> createState() => _AddFuelCardScreenState();
}

final class _AddFuelCardScreenState extends State<AddFuelCardScreen>
    with AddFuelCardMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(LocaleKeys.add_fuel_card.translate)),
      body: BlocConsumer<AddFuelCardBloc, AddFuelCardState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          if (state.status == AddFuelCardStatus.loading) {
            return const Center(child: CustomLoading());
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: context.paddingBase,
              child: _buildBody(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: context.dynamicHeight(0.2),
            child: _buildIcon(),
          ),
          _buildCardTypeInfo(context),
          context.spacingNormalHeight,
          _buildCardNoField(context),
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

  Widget _buildCardTypeInfo(BuildContext context) {
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
            Icon(
              Icons.local_gas_station_rounded,
              color: context.colorScheme.primary,
            ),
            context.spacingNormalWidth,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.card_type.translate,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(164),
                    ),
                  ),
                  Text(
                    LocaleKeys.shell.translate,
                    style: context.textTheme.titleSmall?.copyWith(
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

  Widget _buildCardNoField(BuildContext context) {
    return CustomTextFormField(
      controller: cardNoController,
      hintText: LocaleKeys.enter_card_number.translate,
      labelText: LocaleKeys.card_number.translate,
      prefixIcon: const Icon(Icons.credit_card_rounded),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.enter_card_number_validation.translate;
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryElevatedButton(
      onPressed: onSubmit,
      text: LocaleKeys.add_card.translate,
    );
  }
}
