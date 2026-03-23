import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/managers/user_info_manager.dart';
import 'package:payinall/domain/entities/transaction.dart';
import 'package:payinall/domain/params/transactions_params.dart';
import 'package:payinall/domain/usecases/get_merchant_user_transactions_usecase.dart';
import 'package:payinall/domain/usecases/get_transactions_usecase.dart';
import 'package:payinall/presentation/pages/transaction_history/enum/transaction_filter.dart';

part 'transaction_history_event.dart';
part 'transaction_history_state.dart';

final class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  TransactionHistoryBloc({
    required GetTransactionsUsecase getTransactionsUsecase,
    required GetMerchantUserTransactionsUsecase
    getMerchantUserTransactionsUsecase,
    required UserInfoManager userInfoManager,
  }) : _getTransactionsUsecase = getTransactionsUsecase,
       _getMerchantUserTransactionsUsecase = getMerchantUserTransactionsUsecase,
       _userInfoManager = userInfoManager,
       super(const TransactionHistoryState()) {
    on<TransactionHistoryLoadData>(_onLoadData);
    on<TransactionHistoryFilterChange>(_onFilterChange);
    on<TransactionHistoryDateRangeChange>(_onDateRangeChange);
  }

  final GetTransactionsUsecase _getTransactionsUsecase;
  final GetMerchantUserTransactionsUsecase _getMerchantUserTransactionsUsecase;
  final UserInfoManager _userInfoManager;

  Future<void> _onLoadData(
    TransactionHistoryLoadData event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(state.copyWith(status: TransactionHistoryStatus.loading));

    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));

    final params = TransactionsParams(
      startDate: startDate,
      endDate: endDate,
      transferOperationType: 0,
    );

    final result = _userInfoManager.isMerchant
        ? await _getMerchantUserTransactionsUsecase(params)
        : await _getTransactionsUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: TransactionHistoryStatus.error,
          message: l.message,
        ),
      ),
      (transactions) {
        final filteredTransactions = _getFilteredTransactions(
          transactions,
          state.filter,
        );

        emit(
          state.copyWith(
            status: TransactionHistoryStatus.loaded,
            allTransactions: transactions,
            transactions: filteredTransactions,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      },
    );
  }

  void _onFilterChange(
    TransactionHistoryFilterChange event,
    Emitter<TransactionHistoryState> emit,
  ) {
    if (state.status == TransactionHistoryStatus.loaded) {
      final filteredTransactions = _getFilteredTransactions(
        state.allTransactions ?? [],
        event.filter,
      );

      emit(
        state.copyWith(
          transactions: filteredTransactions,
          filter: event.filter,
        ),
      );
    }
  }

  Future<void> _onDateRangeChange(
    TransactionHistoryDateRangeChange event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(state.copyWith(status: TransactionHistoryStatus.loading));

    final params = TransactionsParams(
      startDate: event.startDate,
      endDate: event.endDate,
      transferOperationType: 0,
    );

    final result = _userInfoManager.isMerchant
        ? await _getMerchantUserTransactionsUsecase(params)
        : await _getTransactionsUsecase(params);

    result.fold(
      (l) => emit(
        state.copyWith(
          status: TransactionHistoryStatus.error,
          message: l.message,
        ),
      ),
      (transactions) {
        final filteredTransactions = _getFilteredTransactions(
          transactions,
          state.filter,
        );

        emit(
          state.copyWith(
            status: TransactionHistoryStatus.loaded,
            allTransactions: transactions,
            transactions: filteredTransactions,
            startDate: event.startDate,
            endDate: event.endDate,
          ),
        );
      },
    );
  }

  List<Transaction> _getFilteredTransactions(
    List<Transaction> transactions,
    TransactionFilter filter,
  ) {
    switch (filter) {
      case TransactionFilter.incoming:
        return transactions.where((t) => t.isIncoming).toList();
      case TransactionFilter.outgoing:
        return transactions.where((t) => !t.isIncoming).toList();
      case TransactionFilter.all:
        return transactions;
    }
  }
}
