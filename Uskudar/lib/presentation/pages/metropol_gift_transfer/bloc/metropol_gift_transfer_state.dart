part of 'metropol_gift_transfer_bloc.dart';

enum MetropolGiftTransferStatus {
  initial,
  loading,
  completed,
  drawBackCompleted,
  error,
}

final class MetropolGiftTransferState extends Equatable {
  const MetropolGiftTransferState({
    this.status = MetropolGiftTransferStatus.initial,
    this.message,
  });

  final MetropolGiftTransferStatus status;
  final String? message;

  MetropolGiftTransferState copyWith({
    MetropolGiftTransferStatus? status,
    String? message,
  }) {
    return MetropolGiftTransferState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
