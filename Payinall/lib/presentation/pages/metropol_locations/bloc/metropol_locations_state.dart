part of 'metropol_locations_bloc.dart';

enum MetropolLocationsStatus {
  initial,
  loading,
  citiesLoaded,
  searching,
  locationsLoaded,
  error,
}

final class MetropolLocationsState extends Equatable {
  const MetropolLocationsState({
    this.status = MetropolLocationsStatus.initial,
    this.cities,
    this.locations,
    this.message,
  });

  final MetropolLocationsStatus status;
  final List<MetropolCity>? cities;
  final List<PointOfSaleLocation>? locations;
  final String? message;

  MetropolLocationsState copyWith({
    MetropolLocationsStatus? status,
    List<MetropolCity>? cities,
    List<PointOfSaleLocation>? locations,
    String? message,
  }) {
    return MetropolLocationsState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      locations: locations ?? this.locations,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, cities, locations, message];
}
