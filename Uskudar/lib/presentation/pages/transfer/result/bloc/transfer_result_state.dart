part of 'transfer_result_bloc.dart';

enum TransferResultStatus { initial, loading, success, error }

final class TransferResultState extends Equatable {
  const TransferResultState({
    this.status = TransferResultStatus.initial,
    this.receipt,
    this.errorMessage,
    this.isSuccess = false,
  });

  final TransferResultStatus status;
  final TransactionReceipt? receipt;
  final String? errorMessage;
  final bool isSuccess;

  TransferResultState copyWith({
    TransferResultStatus? status,
    TransactionReceipt? receipt,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return TransferResultState(
      status: status ?? this.status,
      receipt: receipt ?? this.receipt,
      errorMessage:
          errorMessage ??
          (status == TransferResultStatus.error ? this.errorMessage : null),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [status, receipt, errorMessage, isSuccess];
}
