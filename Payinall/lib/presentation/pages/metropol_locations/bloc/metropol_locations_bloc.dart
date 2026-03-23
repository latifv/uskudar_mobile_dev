import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/metropol_city.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';
import 'package:payinall/domain/params/point_of_sale_location_filter_params.dart';
import 'package:payinall/domain/usecases/get_metropol_cities_usecase.dart';
import 'package:payinall/domain/usecases/get_point_of_sale_location_filter_list_usecase.dart';

part 'metropol_locations_event.dart';
part 'metropol_locations_state.dart';

final class MetropolLocationsBloc
    extends Bloc<MetropolLocationsEvent, MetropolLocationsState> {
  MetropolLocationsBloc({
    required this.getMetropolCitiesUsecase,
    required this.getPointOfSaleLocationFilterListUsecase,
  }) : super(const MetropolLocationsState()) {
    on<MetropolLocationsLoadCities>(_onLoadCities);
    on<MetropolLocationsSearch>(_onSearch);
  }

  final GetMetropolCitiesUsecase getMetropolCitiesUsecase;
  final GetPointOfSaleLocationFilterListUsecase
      getPointOfSaleLocationFilterListUsecase;

  Future<void> _onLoadCities(
    MetropolLocationsLoadCities event,
    Emitter<MetropolLocationsState> emit,
  ) async {
    emit(state.copyWith(status: MetropolLocationsStatus.loading));

    final result = await getMetropolCitiesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolLocationsStatus.error,
          message: failure.message,
        ),
      ),
      (cities) => emit(
        state.copyWith(
          status: MetropolLocationsStatus.citiesLoaded,
          cities: cities,
        ),
      ),
    );
  }

  Future<void> _onSearch(
    MetropolLocationsSearch event,
    Emitter<MetropolLocationsState> emit,
  ) async {
    emit(state.copyWith(status: MetropolLocationsStatus.searching));

    final result = await getPointOfSaleLocationFilterListUsecase(
      PointOfSaleLocationFilterParams(
        name: event.name,
        city: event.city,
        county: event.county,
        metropolTypes: event.metropolTypes,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolLocationsStatus.error,
          message: failure.message,
        ),
      ),
      (locations) => emit(
        state.copyWith(
          status: MetropolLocationsStatus.locationsLoaded,
          locations: locations,
        ),
      ),
    );
  }
}
