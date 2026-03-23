part of 'transfer_confirmation_bloc.dart';

sealed class TransferConfirmationEvent {
  const TransferConfirmationEvent();
}

final class TransferConfirmationSubmit extends TransferConfirmationEvent {
  const TransferConfirmationSubmit({
    required this.walletTransfer,
    required this.withdrawTransfer,
  });

  final WalletTransfer? walletTransfer;
  final WithdrawTransfer? withdrawTransfer;
}
