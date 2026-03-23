import 'dart:async';

import 'package:flutter/material.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/metropol_locations/bloc/metropol_locations_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin MetropolLocationsMixin<T extends StatefulWidget> on State<T> {
  late final MetropolLocationsBloc bloc;
  late final TextEditingController searchController;

  String? selectedCity;
  String? selectedCounty;
  int selectedMetropolType = 0;

  @override
  void initState() {
    super.initState();
    bloc = getIt<MetropolLocationsBloc>();
    searchController = TextEditingController();
    loadCities();
  }

  @override
  void dispose() {
    searchController.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void loadCities() {
    bloc.add(const MetropolLocationsLoadCities());
  }

  void searchLocations() {
    FocusScope.of(context).unfocus();
    bloc.add(
      MetropolLocationsSearch(
        name: searchController.text,
        city: selectedCity ?? '',
        county: selectedCounty ?? '',
        metropolTypes: selectedMetropolType,
      ),
    );
  }

  void onCityChanged(String? city) {
    if (!mounted) return;
    setState(() {
      selectedCity = city;
      selectedCounty = null;
    });
  }

  void onCountyChanged(String? county) {
    if (!mounted) return;
    setState(() {
      selectedCounty = county;
    });
  }

  void onMetropolTypeChanged(int type) {
    if (!mounted) return;
    setState(() {
      selectedMetropolType = type;
    });
  }

  void blocListener(BuildContext context, MetropolLocationsState state) {
    if (state.status == MetropolLocationsStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message ?? '',
      );
    }
  }
}
