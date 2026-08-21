import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/metropol_locations/bloc/metropol_locations_bloc.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';

mixin MetropolLocationsMixin<T extends StatefulWidget> on State<T> {
  late final MetropolLocationsBloc bloc;
  late final TextEditingController searchController;
  late final MapController mapController;

  Timer? _mapDebounce;
  LatLng? currentLocation;
  bool showFilters = false;
  String selectedCategory = 'all';

  String? selectedCity;
  String? selectedCounty;
  int selectedMetropolType = 0;

  @override
  void initState() {
    super.initState();
    bloc = getIt<MetropolLocationsBloc>();
    searchController = TextEditingController();
    searchController.addListener(_refreshLocalFilters);
    mapController = MapController();
    loadCities();
  }

  @override
  void dispose() {
    searchController.dispose();
    _mapDebounce?.cancel();
    mapController.dispose();
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

  void onMapReady() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVisibleMapBounds();
      unawaited(moveToCurrentLocation());
    });
  }

  // flutter_map defines this callback with a positional gesture flag.
  // ignore: avoid_positional_boolean_parameters
  void onMapPositionChanged(MapCamera camera, bool hasGesture) {
    _mapDebounce?.cancel();
    _mapDebounce = Timer(
      const Duration(milliseconds: 650),
      loadVisibleMapBounds,
    );
  }

  void loadVisibleMapBounds() {
    if (!mounted) return;
    final bounds = mapController.camera.visibleBounds;
    bloc.add(
      MetropolLocationsLoadMapBounds(
        lat1: bounds.south.toStringAsFixed(8),
        lat2: bounds.north.toStringAsFixed(8),
        lng1: bounds.west.toStringAsFixed(8),
        lng2: bounds.east.toStringAsFixed(8),
      ),
    );
  }

  Future<void> moveToCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ToastComponent.showErrorToast(
          context: context,
          message: 'Konum servisi kapalı. Lütfen cihaz ayarlarından açın.',
        );
      }
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        ToastComponent.showErrorToast(
          context: context,
          message: 'Yakındaki noktalar için konum izni gereklidir.',
        );
      }
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
    mapController.move(currentLocation!, 14);
  }

  void toggleFilters() {
    setState(() => showFilters = !showFilters);
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'clothing') selectedMetropolType = 1;
      if (category == 'market' || category == 'restaurant') {
        selectedMetropolType = 0;
      }
    });
  }

  void _refreshLocalFilters() {
    if (mounted) setState(() {});
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
