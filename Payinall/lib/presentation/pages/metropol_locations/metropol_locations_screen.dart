import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/presentation/pages/metropol_locations/bloc/metropol_locations_bloc.dart';
import 'package:payinall/presentation/pages/metropol_locations/mixin/metropol_locations_mixin.dart';
import 'package:payinall/presentation/pages/metropol_locations/widgets/location_card.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_empty_list.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';
import 'package:payinall/presentation/widgets/error_try_again.dart';
import 'package:payinall/presentation/widgets/primary_elevated_button.dart';
import 'package:payinall/domain/entities/metropol_city.dart';

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
      appBar: CustomAppBar(
        title: Text(LocaleKeys.point_of_sale_locations.translate),
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
              child: ErrorTryAgain(
                message: state.message,
                onTryAgain: loadCities,
              ),
            ),
            _ => _buildContent(context, state),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MetropolLocationsState state) {
    return Column(
      children: [
        _buildFilterSection(context, state),
        Expanded(child: _buildLocationsList(state)),
      ],
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
      padding: context.paddingBaseLow,
      child: Column(
        children: [
          CustomTextFormField(
            controller: searchController,
            hintText: LocaleKeys.search_store.translate,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
          context.spacingLowHeight,
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
          context.spacingLowHeight,
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(LocaleKeys.market.translate),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(LocaleKeys.clothing.translate),
                ),
              ],
              selected: {selectedMetropolType},
              onSelectionChanged: (value) => onMetropolTypeChanged(value.first),
            ),
          ),
          context.spacingLowHeight,
          PrimaryElevatedButton(
            onPressed: searchLocations,
            text: LocaleKeys.search.translate,
          ),
        ],
      ),
    );
  }

  Widget _buildCityDropdown(
    BuildContext context,
    List<MetropolCity> cities,
  ) {
    return DropdownButtonFormField<String>(
      value: selectedCity,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: LocaleKeys.city.translate,
        hintStyle: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.onSurface.withAlpha(128),
        ),
        filled: true,
        fillColor: context.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(
            color: context.colorScheme.onSurface.withAlpha(128),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: context.paddingNormalHorizontal,
      ),
      items: cities
          .map(
            (city) => DropdownMenuItem(
              value: city.city,
              child: Text(
                city.city,
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
      value: selectedCounty,
      isExpanded: true,
      decoration: InputDecoration(
        hintText: LocaleKeys.county.translate,
        hintStyle: context.textTheme.bodyLarge?.copyWith(
          color: context.colorScheme.onSurface.withAlpha(128),
        ),
        filled: true,
        fillColor: context.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(
            color: context.colorScheme.onSurface.withAlpha(128),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.borderRadiusLowAll,
          borderSide: BorderSide(
            color: context.colorScheme.primary,
            width: 1.5,
          ),
        ),
        contentPadding: context.paddingNormalHorizontal,
      ),
      items: counties
          .map(
            (county) => DropdownMenuItem(
              value: county,
              child: Text(
                county,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: onCountyChanged,
    );
  }

  Widget _buildLocationsList(MetropolLocationsState state) {
    if (state.status == MetropolLocationsStatus.searching) {
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

    if (state.locations!.isEmpty) {
      return Center(
        child: CustomEmptyList(
          iconData: Icons.location_off_outlined,
          title: LocaleKeys.no_results_found_location.translate,
          description: LocaleKeys.no_location_found_description.translate,
        ),
      );
    }

    return ListView.separated(
      padding: context.paddingBaseLow,
      itemCount: state.locations!.length,
      separatorBuilder: (_, __) => context.spacingLowHeight,
      itemBuilder: (context, index) {
        return LocationCard(location: state.locations![index]);
      },
    );
  }
}
