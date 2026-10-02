import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/core/managers/user_info_manager.dart';
import 'package:uskudar_mobile/domain/entities/transaction.dart';
import 'package:uskudar_mobile/domain/params/transactions_params.dart';
import 'package:uskudar_mobile/domain/usecases/get_merchant_user_transactions_usecase.dart';
import 'package:uskudar_mobile/domain/usecases/get_transactions_usecase.dart';
import 'package:uskudar_mobile/presentation/pages/transaction_history/enum/transaction_filter.dart';

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
    on<TransactionHistoryLoadMore>(_onLoadMore);
    on<TransactionHistoryFilterChange>(_onFilterChange);
    on<TransactionHistoryDateRangeChange>(_onDateRangeChange);
  }

  final GetTransactionsUsecase _getTransactionsUsecase;
  final GetMerchantUserTransactionsUsecase _getMerchantUserTransactionsUsecase;
  final UserInfoManager _userInfoManager;
  static const int _pageSize = 20;

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
      pageNumber: 1,
      pageSize: _pageSize,
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
        final sortedTransactions = _sortTransactions(transactions);
        final filteredTransactions = _getFilteredTransactions(
          sortedTransactions,
          state.filter,
        );
        // API, istenen pageSize'dan daha az kayıt döndürebilir. Bu durumda
        // yine de sonraki sayfayı denemek gerekir; sayfalamanın bittiğini
        // boş yanıt geldiğinde anlarız.
        final hasMore = transactions.isNotEmpty;
        emit(
          state.copyWith(
            status: TransactionHistoryStatus.loaded,
            allTransactions: sortedTransactions,
            transactions: filteredTransactions,
            startDate: startDate,
            endDate: endDate,
            pageNumber: 1,
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
        if (filteredTransactions.length < _pageSize && hasMore) {
          add(const TransactionHistoryLoadMore());
        }
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
      if (filteredTransactions.length < _pageSize && state.hasMore) {
        add(const TransactionHistoryLoadMore());
      }
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
      pageNumber: 1,
      pageSize: _pageSize,
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
        final sortedTransactions = _sortTransactions(transactions);
        final filteredTransactions = _getFilteredTransactions(
          sortedTransactions,
          state.filter,
        );
        final hasMore = transactions.isNotEmpty;
        emit(
          state.copyWith(
            status: TransactionHistoryStatus.loaded,
            allTransactions: sortedTransactions,
            transactions: filteredTransactions,
            startDate: event.startDate,
            endDate: event.endDate,
            pageNumber: 1,
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
        if (filteredTransactions.length < _pageSize && hasMore) {
          add(const TransactionHistoryLoadMore());
        }
      },
    );
  }

  Future<void> _onLoadMore(
    TransactionHistoryLoadMore event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    if (state.status != TransactionHistoryStatus.loaded ||
        state.isLoadingMore ||
        !state.hasMore ||
        state.startDate == null ||
        state.endDate == null) {
      return;
    }

    final nextPage = state.pageNumber + 1;
    emit(state.copyWith(isLoadingMore: true));

    final params = TransactionsParams(
      startDate: state.startDate!,
      endDate: state.endDate!,
      transferOperationType: 0,
      pageNumber: nextPage,
      pageSize: _pageSize,
    );
    final result = _userInfoManager.isMerchant
        ? await _getMerchantUserTransactionsUsecase(params)
        : await _getTransactionsUsecase(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          message: failure.message,
        ),
      ),
      (nextTransactions) {
        final currentTransactions = state.allTransactions ?? const [];
        final mergedById = <String, Transaction>{
          for (final transaction in currentTransactions)
            transaction.id: transaction,
          for (final transaction in nextTransactions)
            transaction.id: transaction,
        };
        final mergedTransactions = _sortTransactions(
          mergedById.values.toList(),
        );
        final addedItemCount =
            mergedTransactions.length - currentTransactions.length;

        final filteredTransactions = _getFilteredTransactions(
          mergedTransactions,
          state.filter,
        );
        final hasMore = nextTransactions.isNotEmpty && addedItemCount > 0;

        emit(
          state.copyWith(
            allTransactions: mergedTransactions,
            transactions: filteredTransactions,
            pageNumber: nextPage,
            hasMore: hasMore,
            isLoadingMore: false,
          ),
        );
        if (filteredTransactions.length < _pageSize && hasMore) {
          add(const TransactionHistoryLoadMore());
        }
      },
    );
  }

  List<Transaction> _sortTransactions(List<Transaction> transactions) {
    return [...transactions]..sort((a, b) => b.date.compareTo(a.date));
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
