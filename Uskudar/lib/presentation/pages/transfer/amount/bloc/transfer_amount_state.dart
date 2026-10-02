part of 'transfer_amount_bloc.dart';

final class TransferAmountState extends Equatable {
  const TransferAmountState({
    this.key,
    this.status = TransferAmountStatus.initial,
    this.message,
    this.withdrawTransfer,
    this.walletTransfer,
  });

  final Key? key;
  final TransferAmountStatus status;
  final String? message;
  final WithdrawTransfer? withdrawTransfer;
  final WalletTransfer? walletTransfer;

  TransferAmountState copyWith({
    Key? key,
    TransferAmountStatus? status,
    String? message,
    WithdrawTransfer? withdrawTransfer,
    WalletTransfer? walletTransfer,
  }) {
    return TransferAmountState(
      key: key ?? this.key,
      status: status ?? this.status,
      message: message,
      withdrawTransfer: withdrawTransfer ?? this.withdrawTransfer,
      walletTransfer: walletTransfer ?? this.walletTransfer,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    withdrawTransfer,
    walletTransfer,
    key,
  ];
}
