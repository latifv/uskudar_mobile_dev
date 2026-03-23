import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/metropol_transaction.dart';
import 'package:payinall/domain/params/metropol_transaction_list_params.dart';
import 'package:payinall/domain/usecases/get_metropol_transaction_list_usecase.dart';

part 'metropol_transactions_event.dart';
part 'metropol_transactions_state.dart';

final class MetropolTransactionsBloc
    extends Bloc<MetropolTransactionsEvent, MetropolTransactionsState> {
  MetropolTransactionsBloc({
    required this.getMetropolTransactionListUsecase,
  }) : super(const MetropolTransactionsState()) {
    on<MetropolTransactionsLoad>(_onLoad);
  }

  final GetMetropolTransactionListUsecase getMetropolTransactionListUsecase;

  Future<void> _onLoad(
    MetropolTransactionsLoad event,
    Emitter<MetropolTransactionsState> emit,
  ) async {
    emit(state.copyWith(status: MetropolTransactionsStatus.loading));

    final result = await getMetropolTransactionListUsecase(
      MetropolTransactionListParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MetropolTransactionsStatus.error,
          message: failure.message,
        ),
      ),
      (transactions) => emit(
        state.copyWith(
          status: MetropolTransactionsStatus.loaded,
          transactions: transactions,
        ),
      ),
    );
  }
}
