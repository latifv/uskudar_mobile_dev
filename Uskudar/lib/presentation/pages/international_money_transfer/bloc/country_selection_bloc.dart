import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/country.dart';
import 'package:payinall/domain/entities/country_transaction_type.dart';
import 'package:payinall/domain/usecases/get_country_list_usecase.dart';
import 'package:payinall/domain/usecases/get_country_transaction_type_usecase.dart';

part 'country_selection_event.dart';
part 'country_selection_state.dart';

final class CountrySelectionBloc
    extends Bloc<CountrySelectionEvent, CountrySelectionState> {
  CountrySelectionBloc({
    required GetCountryListUsecase getCountryListUsecase,
    required GetCountryTransactionTypeUsecase getCountryTransactionTypeUsecase,
  }) : _getCountryListUsecase = getCountryListUsecase,
       _getCountryTransactionTypeUsecase = getCountryTransactionTypeUsecase,
       super(const CountrySelectionState()) {
    on<CountrySelectionLoadCountries>(_onLoadCountries);
    on<CountrySelectionLoadTransactionTypes>(_onLoadTransactionTypes);
    on<CountrySelectionReset>(_onReset);
  }

  final GetCountryListUsecase _getCountryListUsecase;
  final GetCountryTransactionTypeUsecase _getCountryTransactionTypeUsecase;

  Future<void> _onLoadCountries(
    CountrySelectionLoadCountries event,
    Emitter<CountrySelectionState> emit,
  ) async {
    emit(state.copyWith(status: CountrySelectionStatus.loadingCountries));

    final result = await _getCountryListUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CountrySelectionStatus.error,
          message: failure.message,
        ),
      ),
      (countries) => emit(
        state.copyWith(
          status: CountrySelectionStatus.countriesLoaded,
          countries: countries,
        ),
      ),
    );
  }

  Future<void> _onLoadTransactionTypes(
    CountrySelectionLoadTransactionTypes event,
    Emitter<CountrySelectionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CountrySelectionStatus.loadingTransactionTypes,
        selectedCountryCode: event.countryCode,
      ),
    );

    final result = await _getCountryTransactionTypeUsecase(event.countryCode);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CountrySelectionStatus.error,
          message: failure.message,
        ),
      ),
      (countryTransactionType) => emit(
        state.copyWith(
          status: CountrySelectionStatus.transactionTypesLoaded,
          countryTransactionType: countryTransactionType,
        ),
      ),
    );
  }

  void _onReset(
    CountrySelectionReset event,
    Emitter<CountrySelectionState> emit,
  ) {
    emit(const CountrySelectionState());
  }
}
