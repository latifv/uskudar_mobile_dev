import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/fuel_card.dart';
import 'package:payinall/domain/usecases/delete_fuel_card_usecase.dart';
import 'package:payinall/domain/usecases/get_fuel_card_balance_usecase.dart';
import 'package:payinall/domain/usecases/get_fuel_cards_usecase.dart';

part 'fuel_cards_event.dart';
part 'fuel_cards_state.dart';

final class FuelCardsBloc extends Bloc<FuelCardsEvent, FuelCardsState> {
  FuelCardsBloc({
    required this.getFuelCardsUsecase,
    required this.deleteFuelCardUsecase,
    required this.getFuelCardBalanceUsecase,
  }) : super(const FuelCardsState()) {
    on<FuelCardsLoad>(_onLoad);
    on<FuelCardDeleteRequested>(_onDelete);
  }

  final GetFuelCardsUsecase getFuelCardsUsecase;
  final DeleteFuelCardUsecase deleteFuelCardUsecase;
  final GetFuelCardBalanceUsecase getFuelCardBalanceUsecase;

  Future<void> _onLoad(
    FuelCardsLoad event,
    Emitter<FuelCardsState> emit,
  ) async {
    emit(state.copyWith(status: FuelCardsStatus.loading));

    final result = await getFuelCardsUsecase();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: FuelCardsStatus.error,
          message: failure.message,
        ),
      ),
      (cards) async {
        final activeCards =
            cards.where((card) => card.isActive).toList();

        final balances = <int, double>{};
        for (final card in activeCards) {
          final balanceResult = await getFuelCardBalanceUsecase(card.id);
          balanceResult.fold(
            (_) {},
            (balance) => balances[card.id] = balance,
          );
        }

        emit(
          state.copyWith(
            status: FuelCardsStatus.loaded,
            cards: activeCards,
            balances: balances,
          ),
        );
      },
    );
  }

  Future<void> _onDelete(
    FuelCardDeleteRequested event,
    Emitter<FuelCardsState> emit,
  ) async {
    emit(state.copyWith(status: FuelCardsStatus.deleting));

    final result = await deleteFuelCardUsecase(event.cardId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: FuelCardsStatus.error,
          message: failure.message,
        ),
      ),
      (message) {
        emit(
          state.copyWith(
            status: FuelCardsStatus.deleted,
            successMessage: message,
          ),
        );
        add(const FuelCardsLoad());
      },
    );
  }
}
