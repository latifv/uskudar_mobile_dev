import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';

final class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.location,
    this.currentLocation,
    this.onTap,
    super.key,
  });

  final PointOfSaleLocation location;
  final LatLng? currentLocation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IntegrationSurface(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IntegrationIconBox(icon: _categoryIcon, size: 44),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.signboardName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _CategoryBadge(label: location.sector),
                    if (location.subSector.isNotEmpty)
                      _CategoryBadge(
                        label: location.subSector,
                        secondary: true,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${location.district}/${location.city} • ${location.saleAddress}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_distanceLabel case final distance?)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      distance,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              if (onTap != null) ...[
                const SizedBox(height: 6),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData get _categoryIcon {
    final sector = '${location.sector} ${location.subSector}'.toLowerCase();
    if (sector.contains('restoran') || sector.contains('cafe')) {
      return Icons.restaurant_rounded;
    }
    if (sector.contains('market')) return Icons.local_grocery_store_rounded;
    if (sector.contains('giyim') || sector.contains('gift')) {
      return Icons.checkroom_rounded;
    }
    return Icons.storefront_rounded;
  }

  String? get _distanceLabel {
    if (currentLocation == null) return null;
    final lat = double.tryParse(location.lat);
    final lng = double.tryParse(location.lng);
    if (lat == null || lng == null) return null;

    final meters = const Distance().as(
      LengthUnit.Meter,
      currentLocation!,
      LatLng(lat, lng),
    );
    if (meters < 1000) return '${meters.round()} m';
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }
}

final class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label, this.secondary = false});

  final String label;
  final bool secondary;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: secondary
            ? context.colorScheme.surfaceContainerHighest
            : context.colorScheme.primary.withAlpha(22),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: secondary
                ? context.colorScheme.onSurfaceVariant
                : context.colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
