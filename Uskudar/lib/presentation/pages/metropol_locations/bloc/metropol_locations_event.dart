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

final class MetropolLocationsLoadMapBounds extends MetropolLocationsEvent {
  const MetropolLocationsLoadMapBounds({
    required this.lat1,
    required this.lat2,
    required this.lng1,
    required this.lng2,
  });

  final String lat1;
  final String lat2;
  final String lng1;
  final String lng2;
}
