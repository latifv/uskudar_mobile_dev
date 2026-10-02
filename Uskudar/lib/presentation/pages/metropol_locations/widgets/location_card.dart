import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:uskudar_mobile/domain/entities/point_of_sale_location.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/theme_extension.dart';
import 'package:uskudar_mobile/presentation/widgets/integration_components.dart';

final class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.location,
    this.currentLocation,
    this.onTap,
    this.expanded = false,
    this.embedded = false,
    super.key,
  });

  final PointOfSaleLocation location;
  final LatLng? currentLocation;
  final VoidCallback? onTap;
  final bool expanded;
  final bool embedded;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          IntegrationIconBox(icon: _categoryIcon, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.signboardName,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AlisverislioColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
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
                const SizedBox(height: 4),
                Text(
                  '${location.district}/${location.city} • ${location.saleAddress}',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: AlisverislioColors.textSecondary,
                  ),
                  maxLines: expanded ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_distanceLabel case final distance?)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AlisverislioColors.textSecondary,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      distance,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AlisverislioColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              if (onTap != null) ...[
                const SizedBox(height: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AlisverislioColors.textSecondary,
                ),
              ],
            ],
          ),
        ],
      ),
    );

    if (embedded) {
      return InkWell(onTap: onTap, child: content);
    }

    return IntegrationSurface(
      onTap: onTap,
      showBorder: false,
      padding: EdgeInsets.zero,
      child: content,
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
        color: secondary ? const Color(0xFFF1F0F4) : AlisverislioColors.lilac,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: secondary
                ? AlisverislioColors.textSecondary
                : AlisverislioColors.primary,
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
