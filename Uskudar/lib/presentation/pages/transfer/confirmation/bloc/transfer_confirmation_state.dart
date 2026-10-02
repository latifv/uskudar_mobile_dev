part of 'transfer_confirmation_bloc.dart';

enum TransferConfirmationStatus { initial, loading, success, error }

final class TransferConfirmationState extends Equatable {
  const TransferConfirmationState({
    this.status = TransferConfirmationStatus.initial,
    this.transactionId,
    this.message,
  });

  final TransferConfirmationStatus status;
  final String? message;
  final String? transactionId;

  TransferConfirmationState copyWith({
    TransferConfirmationStatus? status,
    String? message,
    String? transactionId,
  }) {
    return TransferConfirmationState(
      status: status ?? this.status,
      transactionId: transactionId ?? this.transactionId,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, transactionId, message];
}
