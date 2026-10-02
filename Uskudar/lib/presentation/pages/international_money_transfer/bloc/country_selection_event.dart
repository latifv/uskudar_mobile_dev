part of 'country_selection_bloc.dart';

sealed class CountrySelectionEvent {
  const CountrySelectionEvent();
}

final class CountrySelectionLoadCountries extends CountrySelectionEvent {
  const CountrySelectionLoadCountries();
}

final class CountrySelectionLoadTransactionTypes extends CountrySelectionEvent {
  const CountrySelectionLoadTransactionTypes({required this.countryCode});

  final String countryCode;
}

final class CountrySelectionReset extends CountrySelectionEvent {
  const CountrySelectionReset();
}
