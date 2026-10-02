part of 'transfer_result_bloc.dart';

abstract class TransferResultEvent {
  const TransferResultEvent();
}

final class TransferResultLoadReceipt extends TransferResultEvent {
  const TransferResultLoadReceipt({
    required this.transactionId,
    required this.isSuccess,
  });

  final String transactionId;
  final bool isSuccess;
}

final class TransferResultUpdateStatus extends TransferResultEvent {
  const TransferResultUpdateStatus({required this.isSuccess});

  final bool isSuccess;
}
