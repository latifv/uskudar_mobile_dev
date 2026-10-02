import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/presentation/pages/metropol_locations/bloc/metropol_locations_bloc.dart';
import 'package:payinall/presentation/pages/metropol_locations/mixin/metropol_locations_mixin.dart';
import 'package:payinall/presentation/pages/metropol_locations/widgets/location_card.dart';
import 'package:payinall/presentation/pages/metropol_locations/widgets/metropol_locations_map.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/launch_url_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/integration_components.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';

@RoutePage()
final class MetropolLocationsScreen extends StatefulWidget {
  const MetropolLocationsScreen({super.key});

  @override
  State<MetropolLocationsScreen> createState() =>
      _MetropolLocationsScreenState();
}

final class _MetropolLocationsScreenState extends State<MetropolLocationsScreen>
    with MetropolLocationsMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AlisverislioColors.background,
      appBar: CustomAppBar(
        title: Text(LocaleKeys.shopping.translate),
      ),
      body: BlocConsumer<MetropolLocationsBloc, MetropolLocationsState>(
        bloc: bloc,
        listener: blocListener,
        builder: (context, state) {
          return switch (state.status) {
            MetropolLocationsStatus.initial ||
            MetropolLocationsStatus.loading => const Center(
              child: CustomLoading(),
            ),
            MetropolLocationsStatus.error when state.cities == null => Center(
              child: AlisverislioStateView(
                icon: Icons.cloud_off_rounded,
                title: LocaleKeys.error.translate,
                description:
                    state.message ?? LocaleKeys.general_error.translate,
                actionLabel: LocaleKeys.try_again.translate,
                onAction: loadCities,
                isError: true,
              ),
            ),
            _ => _buildContent(context, state),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MetropolLocationsState state) {
    final visibleLocations = _visibleLocations(state.locations ?? const []);
    return Column(
      children: [
        _buildSearchBar(context),
        _buildCategoryFilters(context),
        if (showFilters) _buildFilterSection(context, state),
        Expanded(
          flex: 48,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
            child: MetropolLocationsMap(
              mapController: mapController,
              locations: visibleLocations,
              currentLocation: currentLocation,
              onMapReady: onMapReady,
              onPositionChanged: onMapPositionChanged,
              onLocationPressed: (location) =>
                  _showLocationDetails(context, location),
              onCurrentLocationPressed: moveToCurrentLocation,
              onOpenMapPressed: _openCurrentMap,
            ),
          ),
        ),
        Expanded(
          flex: 52,
          child: _buildLocationsPanel(context, state, visibleLocations),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: CustomTextFormField(
                controller: searchController,
                hintText: LocaleKeys.search_store.translate,
                prefixIcon: const Icon(Icons.search_rounded, size: 22),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4),
                  child: FilledButton(
                    onPressed: () => FocusScope.of(context).unfocus(),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(LocaleKeys.search.translate),
                  ),
                ),
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox.square(
            dimension: 44,
            child: IconButton.filledTonal(
              onPressed: toggleFilters,
              tooltip: LocaleKeys.filter.translate,
              icon: Icon(
                showFilters ? Icons.close_rounded : Icons.tune_rounded,
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context) {
    final categories = <(String, String)>[
      ('all', LocaleKeys.all.translate),
      ('restaurant', LocaleKeys.restaurant.translate),
      ('market', LocaleKeys.market.translate),
      ('clothing', LocaleKeys.clothing.translate),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (value, label) = categories[index];
          final selected = selectedCategory == value;
          return ChoiceChip(
            selected: selected,
            showCheckmark: false,
            label: Text(label),
            onSelected: (_) => selectCategory(value),
            labelStyle: context.textTheme.labelMedium?.copyWith(
              color: selected ? Colors.white : AlisverislioColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: AlisverislioColors.primary,
            backgroundColor: AlisverislioColors.lilac,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    MetropolLocationsState state,
  ) {
    final cities = state.cities ?? [];
    final counties = cities
        .where((c) => c.city == selectedCity)
        .expand((c) => c.county)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildCityDropdown(context, cities),
              ),
              context.spacingLowWidth,
              Expanded(
                child: _buildCountyDropdown(context, counties),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: PrimaryElevatedButton(
              onPressed: searchLocations,
              text: LocaleKeys.search.translate,
              width: double.infinity,
              height: 42,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(
    BuildContext context,
    MetropolLocationsState state,
    int visibleCount,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: Row(
        children: [
          Text(
            LocaleKeys.point_of_sale_locations.translate,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (state.status == MetropolLocationsStatus.searching)
            const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Text(
              '$visibleCount',
              style: context.textTheme.labelMedium?.copyWith(
                color: AlisverislioColors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocationsPanel(
    BuildContext context,
    MetropolLocationsState state,
    List<PointOfSaleLocation> visibleLocations,
  ) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AlisverislioColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          _buildResultsHeader(context, state, visibleLocations.length),
          Expanded(child: _buildLocationsList(state, visibleLocations)),
        ],
      ),
    );
  }

  Widget _buildCityDropdown(
    BuildContext context,
    List<MetropolCity> cities,
  ) {
    return DropdownButtonFormField<String>(
      key: ValueKey('city-$selectedCity'),
      initialValue: selectedCity,
      isExpanded: true,
      iconSize: 20,
      style: context.textTheme.bodySmall,
      decoration: InputDecoration(
        hintText: LocaleKeys.city.translate,
        hintStyle: context.textTheme.bodySmall?.copyWith(
          color: AlisverislioColors.textSecondary,
        ),
        filled: true,
        fillColor: AlisverislioColors.surface,
        border: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: const BorderSide(
            color: AlisverislioColors.divider,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: const BorderSide(
            color: AlisverislioColors.primary,
            width: 1.5,
          ),
        ),
        constraints: const BoxConstraints(minHeight: 42, maxHeight: 42),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: cities
          .map(
            (city) => DropdownMenuItem(
              value: city.city,
              child: Text(
                city.city,
                style: context.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onCityChanged,
    );
  }

  Widget _buildCountyDropdown(
    BuildContext context,
    List<String> counties,
  ) {
    return DropdownButtonFormField<String>(
      key: ValueKey('county-$selectedCounty'),
      initialValue: selectedCounty,
      isExpanded: true,
      iconSize: 20,
      style: context.textTheme.bodySmall,
      decoration: InputDecoration(
        hintText: LocaleKeys.county.translate,
        hintStyle: context.textTheme.bodySmall?.copyWith(
          color: AlisverislioColors.textSecondary,
        ),
        filled: true,
        fillColor: AlisverislioColors.surface,
        border: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: const BorderSide(
            color: AlisverislioColors.divider,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: const BorderSide(
            color: AlisverislioColors.primary,
            width: 1.5,
          ),
        ),
        constraints: const BoxConstraints(minHeight: 42, maxHeight: 42),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: counties
          .map(
            (county) => DropdownMenuItem(
              value: county,
              child: Text(
                county,
                style: context.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onCountyChanged,
    );
  }

  Widget _buildLocationsList(
    MetropolLocationsState state,
    List<PointOfSaleLocation> visibleLocations,
  ) {
    if (state.status == MetropolLocationsStatus.searching &&
        state.locations == null) {
      return const Center(child: CustomLoading());
    }

    if (state.locations == null) {
      return Center(
        child: CustomEmptyList(
          iconData: Icons.location_on_outlined,
          title: LocaleKeys.search_location.translate,
          description: LocaleKeys.search_location_description.translate,
        ),
      );
    }

    if (visibleLocations.isEmpty) {
      return Center(
        child: CustomEmptyList(
          iconData: Icons.location_off_outlined,
          title: LocaleKeys.no_results_found_location.translate,
          description: LocaleKeys.no_location_found_description.translate,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
      itemCount: visibleLocations.length,
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        indent: 70,
        endIndent: 10,
        color: AlisverislioColors.divider,
      ),
      itemBuilder: (context, index) {
        final location = visibleLocations[index];
        return LocationCard(
          location: location,
          currentLocation: currentLocation,
          onTap: () => _showLocationDetails(context, location),
          embedded: true,
        );
      },
    );
  }

  List<PointOfSaleLocation> _visibleLocations(
    List<PointOfSaleLocation> locations,
  ) {
    final query = searchController.text.trim().toLowerCase();

    return locations.where((location) {
      final searchable = [
        location.signboardName,
        location.sector,
        location.subSector,
        location.saleAddress,
        location.city,
        location.district,
      ].join(' ').toLowerCase();

      if (query.isNotEmpty && !searchable.contains(query)) return false;
      if (selectedCategory == 'all') return true;
      if (selectedCategory == 'restaurant') {
        return searchable.contains('restoran') || searchable.contains('cafe');
      }
      if (selectedCategory == 'market') return searchable.contains('market');
      if (selectedCategory == 'clothing') {
        return searchable.contains('giyim') || searchable.contains('gift');
      }
      return true;
    }).toList();
  }

  void _showLocationDetails(
    BuildContext context,
    PointOfSaleLocation location,
  ) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        backgroundColor: AlisverislioColors.surface,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width,
          maxHeight: MediaQuery.sizeOf(context).height * .58,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LocationCard(
                  location: location,
                  currentLocation: currentLocation,
                  expanded: true,
                  embedded: true,
                ),
                const SizedBox(height: 10),
                _LocationActionTile(
                  icon: Icons.center_focus_strong_rounded,
                  title: 'Odaklan',
                  onTap: () => _focusLocation(context, location),
                ),
                const SizedBox(height: 8),
                _LocationActionTile(
                  icon: Icons.navigation_rounded,
                  title: 'Navigasyon',
                  subtitle:
                      '${location.district}/${location.city} • ${location.saleAddress}',
                  onTap: () => _openNavigation(location),
                ),
                if (location.telNo.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _LocationActionTile(
                    icon: Icons.call_rounded,
                    title: 'Ara',
                    subtitle: location.telNo,
                    onTap: () => _callLocation(location),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _focusLocation(
    BuildContext sheetContext,
    PointOfSaleLocation location,
  ) {
    final lat = double.tryParse(location.lat);
    final lng = double.tryParse(location.lng);
    if (lat == null || lng == null) return;
    Navigator.of(sheetContext).pop();
    mapController.move(LatLng(lat, lng), 16);
  }

  Future<void> _openNavigation(PointOfSaleLocation location) async {
    final lat = double.tryParse(location.lat);
    final lng = double.tryParse(location.lng);
    if (lat == null || lng == null) return;
    await 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng'
        .launchAsUrl();
  }

  Future<void> _callLocation(PointOfSaleLocation location) async {
    final phone = location.telNo.replaceAll(RegExp('[^0-9+]'), '');
    if (phone.isEmpty) return;
    await 'tel:$phone'.launchAsUrl();
  }

  Future<void> _openCurrentMap() async {
    final center = mapController.camera.center;
    await 'https://www.google.com/maps/search/?api=1&query='
            '${center.latitude},${center.longitude}'
        .launchAsUrl();
  }
}

final class _LocationActionTile extends StatelessWidget {
  const _LocationActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AlisverislioColors.background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AlisverislioColors.textPrimary, size: 23),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AlisverislioColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle case final value?) ...[
                      const SizedBox(height: 2),
                      Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AlisverislioColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AlisverislioColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
