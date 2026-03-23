import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/params/fuel_card_top_up_params.dart';
import 'package:payinall/domain/usecases/fuel_card_top_up_usecase.dart';
import 'package:payinall/domain/usecases/get_fuel_card_balance_usecase.dart';

part 'fuel_card_top_up_event.dart';
part 'fuel_card_top_up_state.dart';

final class FuelCardTopUpBloc
    extends Bloc<FuelCardTopUpEvent, FuelCardTopUpState> {
  FuelCardTopUpBloc({
    required this.fuelCardTopUpUsecase,
    required this.getFuelCardBalanceUsecase,
  }) : super(const FuelCardTopUpState()) {
    on<FuelCardTopUpLoadBalance>(_onLoadBalance);
    on<FuelCardTopUpSubmit>(_onSubmit);
  }

  final FuelCardTopUpUsecase fuelCardTopUpUsecase;
  final GetFuelCardBalanceUsecase getFuelCardBalanceUsecase;

  Future<void> _onLoadBalance(
    FuelCardTopUpLoadBalance event,
    Emitter<FuelCardTopUpState> emit,
  ) async {
    emit(state.copyWith(status: FuelCardTopUpStatus.loadingBalance));

    final result = await getFuelCardBalanceUsecase(event.fuelCardId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FuelCardTopUpStatus.loaded,
          message: failure.message,
        ),
      ),
      (balance) => emit(
        state.copyWith(
          status: FuelCardTopUpStatus.loaded,
          balance: balance,
        ),
      ),
    );
  }

  Future<void> _onSubmit(
    FuelCardTopUpSubmit event,
    Emitter<FuelCardTopUpState> emit,
  ) async {
    emit(state.copyWith(status: FuelCardTopUpStatus.submitting));

    final result = await fuelCardTopUpUsecase(
      FuelCardTopUpParams(
        fuelCardId: event.fuelCardId,
        amount: event.amount,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FuelCardTopUpStatus.error,
          message: failure.message,
        ),
      ),
      (message) => emit(
        state.copyWith(
          status: FuelCardTopUpStatus.success,
          message: message,
        ),
      ),
    );
  }
}
