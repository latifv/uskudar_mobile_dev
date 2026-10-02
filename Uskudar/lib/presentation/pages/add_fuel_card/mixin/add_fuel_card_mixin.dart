import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:uskudar_mobile/di/di.dart';
import 'package:uskudar_mobile/domain/entities/fuel_provider.dart';
import 'package:uskudar_mobile/presentation/pages/add_fuel_card/add_fuel_card_screen.dart';
import 'package:uskudar_mobile/presentation/pages/add_fuel_card/bloc/add_fuel_card_bloc.dart';
import 'package:uskudar_mobile/presentation/shared/components/toast_component.dart';

mixin AddFuelCardMixin on State<AddFuelCardScreen> {
  late final AddFuelCardBloc bloc;
  late final TextEditingController cardNoController;
  late final TextEditingController plateController;
  late final GlobalKey<FormState> formKey;
  FuelType selectedFuelType = FuelType.gasoline;

  @override
  void initState() {
    super.initState();
    bloc = getIt<AddFuelCardBloc>();
    cardNoController = TextEditingController();
    plateController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    cardNoController.dispose();
    plateController.dispose();
    formKey.currentState?.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void onSubmit() {
    FocusScope.of(context).unfocus();
    if (formKey.currentState?.validate() != true) return;
    bloc.add(
      AddFuelCardSubmit(
        cardNo: cardNoController.text.trim(),
        cardType: widget.provider.cardType,
        plate: widget.provider.requiresVehicleDetails
            ? plateController.text.trim().toUpperCase()
            : null,
        fuelType: widget.provider.requiresVehicleDetails
            ? selectedFuelType.apiValue
            : null,
      ),
    );
  }

  void onFuelTypeChanged(FuelType? value) {
    if (value == null) return;
    setState(() => selectedFuelType = value);
  }

  void blocListener(BuildContext context, AddFuelCardState state) {
    if (state.status == AddFuelCardStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
    if (state.status == AddFuelCardStatus.success) {
      ToastComponent.showSuccessToast(
        context: context,
        message: state.message ?? '',
      );
      unawaited(context.router.maybePop());
    }
  }
}
