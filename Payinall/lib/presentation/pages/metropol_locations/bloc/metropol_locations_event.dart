part of 'metropol_locations_bloc.dart';

sealed class MetropolLocationsEvent {
  const MetropolLocationsEvent();
}

final class MetropolLocationsLoadCities extends MetropolLocationsEvent {
  const MetropolLocationsLoadCities();
}

final class MetropolLocationsSearch extends MetropolLocationsEvent {
  const MetropolLocationsSearch({
    required this.name,
    required this.city,
    required this.county,
    required this.metropolTypes,
  });

  final String name;
  final String city;
  final String county;
  final int metropolTypes;
}
