part of 'country_selection_bloc.dart';

enum CountrySelectionStatus {
  initial,
  loadingCountries,
  countriesLoaded,
  loadingTransactionTypes,
  transactionTypesLoaded,
  error,
}

final class CountrySelectionState extends Equatable {
  const CountrySelectionState({
    this.status = CountrySelectionStatus.initial,
    this.countries,
    this.countryTransactionType,
    this.selectedCountryCode,
    this.message,
  });

  final CountrySelectionStatus status;
  final List<Country>? countries;
  final CountryTransactionType? countryTransactionType;
  final String? selectedCountryCode;
  final String? message;

  CountrySelectionState copyWith({
    CountrySelectionStatus? status,
    List<Country>? countries,
    CountryTransactionType? countryTransactionType,
    String? selectedCountryCode,
    String? message,
  }) {
    return CountrySelectionState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      countryTransactionType:
          countryTransactionType ?? this.countryTransactionType,
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    countries,
    countryTransactionType,
    selectedCountryCode,
    message,
  ];
}
