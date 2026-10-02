import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/di/di.dart';
import 'package:payinall/domain/entities/country.dart';
import 'package:payinall/presentation/pages/international_money_transfer/bloc/country_selection_bloc.dart';
import 'package:payinall/presentation/route/app_router.dart';
import 'package:payinall/presentation/shared/components/toast_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/padding_extension.dart';
import 'package:payinall/presentation/shared/extensions/spacing_extension.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';
import 'package:payinall/presentation/shared/extensions/theme_extension.dart';
import 'package:payinall/presentation/widgets/custom_app_bar.dart';
import 'package:payinall/presentation/widgets/custom_loading.dart';
import 'package:payinall/presentation/widgets/custom_text_form_field.dart';

@RoutePage()
final class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

final class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  late final CountrySelectionBloc bloc;
  late final TextEditingController searchController;
  List<Country> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    bloc = getIt<CountrySelectionBloc>();
    searchController = TextEditingController();
    bloc.add(const CountrySelectionLoadCountries());
  }

  @override
  void dispose() {
    searchController.dispose();
    unawaited(bloc.close());
    super.dispose();
  }

  void _blocListener(BuildContext context, CountrySelectionState state) {
    if (state.status == CountrySelectionStatus.error) {
      ToastComponent.showErrorToast(
        context: context,
        message: state.message,
      );
    } else if (state.status == CountrySelectionStatus.countriesLoaded) {
      setState(() {
        filteredCountries = state.countries ?? [];
      });
    }
  }

  void _onSearchChanged(String query) {
    final countries = bloc.state.countries ?? [];
    setState(() {
      if (query.isEmpty) {
        filteredCountries = countries;
      } else {
        filteredCountries = countries
            .where(
              (c) => c.countryName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _onCountrySelected(String countryCode) {
    unawaited(
      context.router.push(
        TransactionTypeSelectionRoute(countryCode: countryCode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(LocaleKeys.select_country.translate),
      ),
      body: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<CountrySelectionBloc, CountrySelectionState>(
          listener: _blocListener,
          builder: (context, state) {
            if (state.status == CountrySelectionStatus.loadingCountries) {
              return const Center(child: CustomLoading());
            }

            if (state.status == CountrySelectionStatus.error &&
                (state.countries == null || state.countries!.isEmpty)) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message ?? LocaleKeys.general_error.translate,
                      textAlign: TextAlign.center,
                    ),
                    context.spacingNormalHeight,
                    ElevatedButton(
                      onPressed: () =>
                          bloc.add(const CountrySelectionLoadCountries()),
                      child: Text(LocaleKeys.retry.translate),
                    ),
                  ],
                ),
              );
            }

            return _buildContent(context);
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: context.paddingNormalHorizontal,
            child: CustomTextFormField(
              controller: searchController,
              hintText: LocaleKeys.search.translate,
              prefixIcon: const Icon(Icons.search),
              onChanged: _onSearchChanged,
            ),
          ),
          context.spacingNormalHeight,
          Expanded(
            child: filteredCountries.isEmpty
                ? Center(child: Text(LocaleKeys.no_data.translate))
                : ListView.builder(
                    padding: context.paddingNormalHorizontal,
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return _buildCountryTile(context, country);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryTile(BuildContext context, Country country) {
    return Card(
      margin: context.paddingNormalBottom,
      child: InkWell(
        onTap: () => _onCountrySelected(country.countryCode),
        borderRadius: context.borderRadiusNormalAll,
        child: Padding(
          padding: context.paddingNormalAll,
          child: Row(
            children: [
              Flag.fromString(
                country.countryCode,
                width: 40,
                height: 40,
              ),
              context.spacingNormalWidth,
              Expanded(
                child: Text(
                  country.countryName,
                  style: context.textTheme.bodyLarge,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
