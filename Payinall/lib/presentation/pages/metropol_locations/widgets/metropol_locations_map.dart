import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';

final class MetropolLocationsMap extends StatelessWidget {
  const MetropolLocationsMap({
    required this.mapController,
    required this.locations,
    required this.onMapReady,
    required this.onPositionChanged,
    required this.onLocationPressed,
    required this.onCurrentLocationPressed,
    this.currentLocation,
    super.key,
  });

  final MapController mapController;
  final List<PointOfSaleLocation> locations;
  final VoidCallback onMapReady;
  final PositionCallback onPositionChanged;
  final ValueChanged<PointOfSaleLocation> onLocationPressed;
  final VoidCallback onCurrentLocationPressed;
  final LatLng? currentLocation;

  @override
  Widget build(BuildContext context) {
    final markers = locations
        .map((location) {
          final lat = double.tryParse(location.lat);
          final lng = double.tryParse(location.lng);
          if (lat == null || lng == null) return null;

          return Marker(
            point: LatLng(lat, lng),
            width: 46,
            height: 46,
            child: GestureDetector(
              onTap: () => onLocationPressed(location),
              child: _StoreMarker(color: context.colorScheme.primary),
            ),
          );
        })
        .whereType<Marker>()
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
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
                      color: context.colorScheme.primary,
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
                          color: context.colorScheme.onPrimary,
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
                          color: context.colorScheme.primary,
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
          Positioned(
            left: 12,
            bottom: 34,
            child: _MapControl(
              onPressed: onCurrentLocationPressed,
              icon: Icons.my_location_rounded,
              tooltip: 'Konumum',
            ),
          ),
          Positioned(
            right: 12,
            bottom: 34,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
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
                  ),
                  SizedBox(
                    height: 22,
                    child: VerticalDivider(
                      width: 1,
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                  _MapControl(
                    onPressed: () => _changeZoom(1),
                    icon: Icons.add_rounded,
                    tooltip: 'Yakınlaştır',
                    showShadow: false,
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
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String tooltip;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: showShadow
            ? const [BoxShadow(color: Colors.black26, blurRadius: 8)]
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        color: context.colorScheme.primary,
        icon: Icon(icon),
      ),
    );
  }
}

final class _StoreMarker extends StatelessWidget {
  const _StoreMarker({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Icon(
          Icons.location_on_rounded,
          color: color,
          size: 46,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 6)],
        ),
        Positioned(
          top: 8,
          child: Icon(
            Icons.storefront_rounded,
            color: context.colorScheme.onPrimary,
            size: 17,
          ),
        ),
      ],
    );
  }
}
