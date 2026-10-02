import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/entities/transaction_receipt.dart';
import 'package:uskudar_mobile/domain/usecases/get_transaction_receipt_usecase.dart';

part 'transfer_result_event.dart';
part 'transfer_result_state.dart';

final class TransferResultBloc
    extends Bloc<TransferResultEvent, TransferResultState> {
  TransferResultBloc({
    required GetTransactionReceiptUsecase getTransactionReceiptUsecase,
  }) : _getTransactionReceiptUsecase = getTransactionReceiptUsecase,
       super(const TransferResultState()) {
    on<TransferResultLoadReceipt>(_onLoadReceipt);
    on<TransferResultUpdateStatus>(_onUpdateStatus);
  }

  final GetTransactionReceiptUsecase _getTransactionReceiptUsecase;

  Future<void> _onLoadReceipt(
    TransferResultLoadReceipt event,
    Emitter<TransferResultState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TransferResultStatus.loading,
        isSuccess: event.isSuccess,
      ),
    );

    final result = await _getTransactionReceiptUsecase(event.transactionId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: TransferResultStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (receipt) => emit(
        state.copyWith(
          status: TransferResultStatus.success,
          receipt: receipt,
          isSuccess: event.isSuccess,
        ),
      ),
    );
  }

  void _onUpdateStatus(
    TransferResultUpdateStatus event,
    Emitter<TransferResultState> emit,
  ) {
    emit(
      state.copyWith(
        status: TransferResultStatus.success,
        isSuccess: event.isSuccess,
      ),
    );
  }
}
