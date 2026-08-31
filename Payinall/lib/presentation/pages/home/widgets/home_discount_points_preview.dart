import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/presentation/pages/metropol_locations/bloc/metropol_locations_bloc.dart';
import 'package:payinall/presentation/pages/metropol_locations/widgets/metropol_locations_map.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class HomeDiscountPointsPreview extends StatefulWidget {
  const HomeDiscountPointsPreview({super.key});

  @override
  State<HomeDiscountPointsPreview> createState() =>
      _HomeDiscountPointsPreviewState();
}

final class _HomeDiscountPointsPreviewState
    extends State<HomeDiscountPointsPreview> {
  late final MetropolLocationsBloc _bloc;
  late final MapController _mapController;

  LatLng? _currentLocation;
  bool _mapReady = false;
  bool _locationResolved = false;
  bool _locationPermissionUnavailable = false;
  bool _boundsLoaded = false;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<MetropolLocationsBloc>();
    _mapController = MapController();
    unawaited(_resolveLocation());
  }

  @override
  void dispose() {
    _mapController.dispose();
    unawaited(_bloc.close());
    super.dispose();
  }

  Future<void> _resolveLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    var permission = await Geolocator.checkPermission();
    if (serviceEnabled && permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final canUseLocation =
        serviceEnabled &&
        permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever;

    LatLng? location;
    if (canUseLocation) {
      try {
        final position = await Geolocator.getCurrentPosition();
        location = LatLng(position.latitude, position.longitude);
      } on Exception {
        location = null;
      }
    }

    if (!mounted) return;
    setState(() {
      _currentLocation = location;
      _locationResolved = true;
      _locationPermissionUnavailable = location == null;
    });
    _positionAndLoad();
  }

  void _onMapReady() {
    _mapReady = true;
    _positionAndLoad();
  }

  void _positionAndLoad() {
    if (!_mapReady || !_locationResolved || _boundsLoaded) return;
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 13);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _boundsLoaded) return;
      final bounds = _mapController.camera.visibleBounds;
      _boundsLoaded = true;
      _bloc.add(
        MetropolLocationsLoadMapBounds(
          lat1: bounds.south.toStringAsFixed(8),
          lat2: bounds.north.toStringAsFixed(8),
          lng1: bounds.west.toStringAsFixed(8),
          lng2: bounds.east.toStringAsFixed(8),
        ),
      );
    });
  }

  void _openFullMap() {
    unawaited(context.router.push(const MetropolLocationsRoute()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                LocaleKeys.payinall_discount_points.translate,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: _openFullMap,
              child: Text(
                LocaleKeys.view_all.translate,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 220,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Material(
              color: context.colorScheme.surfaceContainerLow,
              child: InkWell(
                onTap: _openFullMap,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    BlocBuilder<MetropolLocationsBloc, MetropolLocationsState>(
                      bloc: _bloc,
                      builder: (context, state) {
                        return AbsorbPointer(
                          child: MetropolLocationsMap(
                            mapController: _mapController,
                            locations: state.locations ?? const [],
                            currentLocation: _currentLocation,
                            showControls: false,
                            onMapReady: _onMapReady,
                            onPositionChanged: (_, _) {},
                            onLocationPressed: (_) {},
                            onCurrentLocationPressed: () {},
                            onOpenMapPressed: _openFullMap,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<MetropolLocationsBloc, MetropolLocationsState>(
                      bloc: _bloc,
                      buildWhen: (previous, current) =>
                          previous.status != current.status ||
                          previous.locations != current.locations,
                      builder: (context, state) {
                        if (state.status == MetropolLocationsStatus.error) {
                          return _MessageOverlay(
                            icon: Icons.location_off_outlined,
                            message:
                                LocaleKeys.no_nearby_discount_points.translate,
                          );
                        }
                        if (state.status ==
                                MetropolLocationsStatus.locationsLoaded &&
                            (state.locations?.isEmpty ?? true)) {
                          return _MessageOverlay(
                            icon: Icons.storefront_outlined,
                            message:
                                LocaleKeys.no_nearby_discount_points.translate,
                          );
                        }
                        if (state.status == MetropolLocationsStatus.searching ||
                            !_locationResolved) {
                          return const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    if (_locationPermissionUnavailable)
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colorScheme.surface.withValues(
                              alpha: 0.94,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              LocaleKeys
                                  .discount_points_location_permission
                                  .translate,
                              style: context.textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

final class _MessageOverlay extends StatelessWidget {
  const _MessageOverlay({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.surface.withValues(alpha: 0.9),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: context.colorScheme.primary),
              const SizedBox(height: 8),
              Text(
                message,
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
