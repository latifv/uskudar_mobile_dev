import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class MetropolLocationsMap extends StatelessWidget {
  const MetropolLocationsMap({
    required this.mapController,
    required this.locations,
    required this.onMapReady,
    required this.onPositionChanged,
    required this.onLocationPressed,
    required this.onCurrentLocationPressed,
    required this.onOpenMapPressed,
    this.currentLocation,
    this.showControls = true,
    super.key,
  });

  final MapController mapController;
  final List<PointOfSaleLocation> locations;
  final VoidCallback onMapReady;
  final PositionCallback onPositionChanged;
  final ValueChanged<PointOfSaleLocation> onLocationPressed;
  final VoidCallback onCurrentLocationPressed;
  final VoidCallback onOpenMapPressed;
  final LatLng? currentLocation;
  final bool showControls;

  @override
  Widget build(BuildContext context) {
    final markers = locations
        .map((location) {
          final lat = double.tryParse(location.lat);
          final lng = double.tryParse(location.lng);
          if (lat == null || lng == null) return null;

          return Marker(
            point: LatLng(lat, lng),
            width: 44,
            height: 48,
            child: GestureDetector(
              onTap: () => onLocationPressed(location),
              child: _StoreMarker(icon: _categoryIcon(location)),
            ),
          );
        })
        .whereType<Marker>()
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(41.0082, 28.9784),
              minZoom: 5,
              maxZoom: 18,
              onMapReady: onMapReady,
              onPositionChanged: onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.erpapay.payinall',
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  markers: markers,
                  maxClusterRadius: 55,
                  size: const Size(42, 42),
                  maxZoom: 18,
                  disableClusteringAtZoom: 17,
                  markerChildBehavior: true,
                  builder: (context, clusteredMarkers) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: AlisverislioColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 8),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${clusteredMarkers.length}',
                        style: context.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation!,
                      width: 26,
                      height: 26,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AlisverislioColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
          if (showControls)
            Positioned(
              left: 12,
              bottom: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AlisverislioColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapControl(
                      onPressed: onOpenMapPressed,
                      icon: Icons.open_in_new_rounded,
                      tooltip: 'Haritada aç',
                      showShadow: false,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                    _MapControl(
                      onPressed: onCurrentLocationPressed,
                      icon: Icons.my_location_rounded,
                      tooltip: 'Konumum',
                      showShadow: false,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          if (showControls)
            Positioned(
              right: 12,
              bottom: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AlisverislioColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MapControl(
                      onPressed: () => _changeZoom(-1),
                      icon: Icons.remove_rounded,
                      tooltip: 'Uzaklaştır',
                      showShadow: false,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(
                      height: 22,
                      child: VerticalDivider(
                        width: 1,
                        color: Colors.white38,
                      ),
                    ),
                    _MapControl(
                      onPressed: () => _changeZoom(1),
                      icon: Icons.add_rounded,
                      tooltip: 'Yakınlaştır',
                      showShadow: false,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _changeZoom(double delta) {
    final camera = mapController.camera;
    final targetZoom = (camera.zoom + delta).clamp(5, 18).toDouble();
    mapController.move(camera.center, targetZoom);
  }
}

final class _MapControl extends StatelessWidget {
  const _MapControl({
    required this.onPressed,
    required this.icon,
    required this.tooltip,
    this.showShadow = true,
    this.foregroundColor = AlisverislioColors.primary,
    this.backgroundColor = AlisverislioColors.surface,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;
  final bool showShadow;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? const [BoxShadow(color: Colors.black26, blurRadius: 8)]
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        color: foregroundColor,
        icon: Icon(icon),
      ),
    );
  }
}

IconData _categoryIcon(PointOfSaleLocation location) {
  final value = '${location.sector} ${location.subSector}'.toLowerCase();
  if (value.contains('restoran') || value.contains('cafe')) {
    return Icons.restaurant_rounded;
  }
  if (value.contains('market')) return Icons.local_grocery_store_rounded;
  if (value.contains('giyim') || value.contains('gift')) {
    return Icons.checkroom_rounded;
  }
  return Icons.storefront_rounded;
}

final class _StoreMarker extends StatelessWidget {
  const _StoreMarker({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const Positioned(
          bottom: 0,
          child: Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.white,
            size: 25,
          ),
        ),
        Positioned(
          top: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 7),
              ],
              border: Border.all(
                color: AlisverislioColors.lilac,
                width: 1.5,
              ),
            ),
            child: SizedBox.square(
              dimension: 37,
              child: Icon(
                icon,
                color: AlisverislioColors.primary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
