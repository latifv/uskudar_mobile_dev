import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/transaction_receipt.dart';
import 'package:payinall/domain/usecases/get_transaction_receipt_usecase.dart';

part 'transaction_detail_event.dart';
part 'transaction_detail_state.dart';

final class TransactionDetailBloc
    extends Bloc<TransactionDetailEvent, TransactionDetailState> {
  TransactionDetailBloc({
    required GetTransactionReceiptUsecase getTransactionReceiptUsecase,
  }) : _getTransactionReceiptUsecase = getTransactionReceiptUsecase,
       super(const TransactionDetailState()) {
    on<TransactionDetailLoadData>(_onLoadTransactionData);
  }

  final GetTransactionReceiptUsecase _getTransactionReceiptUsecase;

  Future<void> _onLoadTransactionData(
    TransactionDetailLoadData event,
    Emitter<TransactionDetailState> emit,
  ) async {
    emit(state.copyWith(status: TransactionDetailStatus.loading));

    final transactionReceiptResult = await _getTransactionReceiptUsecase(
      event.transactionId,
    );

    transactionReceiptResult.fold(
      (failure) => emit(
        state.copyWith(
          status: TransactionDetailStatus.error,
          message: failure.message,
        ),
      ),
      (receipt) => emit(
        state.copyWith(
          status: TransactionDetailStatus.loaded,
          receipt: receipt,
        ),
      ),
    );
  }
}
