import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/wrong_password_history.dart';
import 'package:payinall/domain/usecases/get_current_customer_wrong_password_histories_usecase.dart';

part 'wrong_login_attempts_event.dart';
part 'wrong_login_attempts_state.dart';

final class WrongLoginAttemptsBloc
    extends Bloc<WrongLoginAttemptsEvent, WrongLoginAttemptsState> {
  WrongLoginAttemptsBloc({
    required this.getCurrentCustomerWrongPasswordHistoriesUsecase,
  }) : super(const WrongLoginAttemptsState()) {
    on<WrongLoginAttemptsLoadData>(_loadData);
  }

  final GetCurrentCustomerWrongPasswordHistoriesUsecase
  getCurrentCustomerWrongPasswordHistoriesUsecase;

  Future<void> _loadData(
    WrongLoginAttemptsLoadData event,
    Emitter<WrongLoginAttemptsState> emit,
  ) async {
    emit(state.copyWith(status: WrongLoginAttemptsStatus.loading));

    final result = await getCurrentCustomerWrongPasswordHistoriesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WrongLoginAttemptsStatus.error,
          message: failure.message,
        ),
      ),
      (wrongPasswordHistories) => emit(
        state.copyWith(
          status: WrongLoginAttemptsStatus.loaded,
          wrongPasswordHistories: wrongPasswordHistories,
        ),
      ),
    );
  }
}
