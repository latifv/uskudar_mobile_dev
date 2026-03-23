part of 'metropol_transfer_bloc.dart';

enum MetropolTransferStatus {
  initial,
  loading,
  transferReady,
  confirming,
  completed,
  drawBackCompleted,
  error,
}

final class MetropolTransferState extends Equatable {
  const MetropolTransferState({
    this.status = MetropolTransferStatus.initial,
    this.transferResult,
    this.message,
  });

  final MetropolTransferStatus status;
  final MetropolTransferResult? transferResult;
  final String? message;

  MetropolTransferState copyWith({
    MetropolTransferStatus? status,
    MetropolTransferResult? transferResult,
    String? message,
  }) {
    return MetropolTransferState(
      status: status ?? this.status,
      transferResult: transferResult ?? this.transferResult,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, transferResult, message];
}
