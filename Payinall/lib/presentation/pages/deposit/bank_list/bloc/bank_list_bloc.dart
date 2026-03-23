import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/usecases/get_app_banks_usecase.dart';
import 'package:payinall/presentation/pages/deposit/bank_list/bloc/bank_list_event.dart';
import 'package:payinall/presentation/pages/deposit/bank_list/bloc/bank_list_state.dart';

final class BankListBloc extends Bloc<BankListEvent, BankListState> {
  BankListBloc({required this.getAppBanksUsecase})
    : super(const BankListState()) {
    on<BankListFetched>(_onBankListFetched);
    on<BankSelected>(_onBankSelected);
  }

  final GetAppBanksUsecase getAppBanksUsecase;

  Future<void> _onBankListFetched(
    BankListFetched event,
    Emitter<BankListState> emit,
  ) async {
    emit(state.copyWith(status: BankListStatus.loading));

    final result = await getAppBanksUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(status: BankListStatus.error, message: failure.message),
      ),
      (banks) =>
          emit(state.copyWith(status: BankListStatus.loaded, banks: banks)),
    );
  }

  void _onBankSelected(BankSelected event, Emitter<BankListState> emit) {
    final currentState = state;
    if (currentState.status == BankListStatus.loaded) {
      emit(currentState.copyWith(selectedBankId: event.bankId));
    }
  }
}
