import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/fuel_provider.dart';
import 'package:payinall/presentation/pages/add_fuel_card/bloc/add_fuel_card_bloc.dart';
import 'package:payinall/presentation/pages/add_fuel_card/mixin/add_fuel_card_mixin.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class AddFuelCardScreen extends StatefulWidget {
  const AddFuelCardScreen({this.provider = FuelProvider.shell, super.key});

  final FuelProvider provider;

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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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
          _buildIntro(context),
          const SizedBox(height: 16),
          _buildCardTypeInfo(context),
          const SizedBox(height: 12),
          _buildCardNoField(context),
          if (widget.provider.requiresVehicleDetails) ...[
            const SizedBox(height: 12),
            _buildPlateField(context),
            const SizedBox(height: 12),
            _buildFuelTypeField(context),
          ],
          const SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return Row(
      children: [
        const IntegrationIconBox(
          icon: Icons.local_gas_station_rounded,
          size: 48,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            LocaleKeys.add_fuel_card.translate,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardTypeInfo(BuildContext context) {
    return IntegrationSurface(
      backgroundColor: context.colorScheme.primary.withAlpha(12),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const IntegrationIconBox(
            icon: Icons.local_gas_station_rounded,
            size: 38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.card_type.translate,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  widget.provider.name,
                  style: context.textTheme.bodySmall?.copyWith(
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

  Widget _buildPlateField(BuildContext context) {
    return CustomTextFormField(
      controller: plateController,
      hintText: LocaleKeys.fuel_plate_hint.translate,
      labelText: LocaleKeys.fuel_plate.translate,
      prefixIcon: const Icon(Icons.directions_car_outlined),
      textCapitalization: TextCapitalization.characters,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return LocaleKeys.fuel_plate_required.translate;
        }
        return null;
      },
    );
  }

  Widget _buildFuelTypeField(BuildContext context) {
    return DropdownButtonFormField<FuelType>(
      initialValue: selectedFuelType,
      decoration: InputDecoration(
        labelText: LocaleKeys.fuel_type.translate,
        prefixIcon: const Icon(Icons.local_gas_station_outlined),
      ),
      items: FuelType.values
          .map(
            (fuelType) => DropdownMenuItem(
              value: fuelType,
              child: Text(
                fuelType == FuelType.gasoline
                    ? LocaleKeys.fuel_gasoline.translate
                    : LocaleKeys.fuel_diesel.translate,
              ),
            ),
          )
          .toList(),
      onChanged: onFuelTypeChanged,
    );
  }

  Widget _buildCardNoField(BuildContext context) {
    return CustomTextFormField(
      controller: cardNoController,
      hintText: widget.provider.cardNumberHint,
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
