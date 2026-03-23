enum TransferOperationType {
  all,
  walletSenderTransfer,
  withdraw,
  deposit,
  bill,
  walletBuyerTransfer,
  differentAccountWithdraw,
  differentAccountDeposit,
  passiveAccountFee,
  fraud;

  const TransferOperationType();

  int get value {
    switch (this) {
      case TransferOperationType.all:
        return 0;
      case TransferOperationType.walletSenderTransfer:
        return 1;
      case TransferOperationType.withdraw:
        return 2;
      case TransferOperationType.deposit:
        return 3;
      case TransferOperationType.bill:
        return 4;
      case TransferOperationType.walletBuyerTransfer:
        return 5;
      case TransferOperationType.differentAccountWithdraw:
        return 6;
      case TransferOperationType.differentAccountDeposit:
        return 7;
      case TransferOperationType.passiveAccountFee:
        return 8;
      case TransferOperationType.fraud:
        return 9;
    }
  }
}
