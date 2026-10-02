enum TransferMethod {
  wallet,
  phone,
  bankAccount;

  const TransferMethod();

  int get value {
    switch (this) {
      case TransferMethod.wallet:
        return 0;
      case TransferMethod.phone:
        return 1;
      case TransferMethod.bankAccount:
        return 2;
    }
  }
}

extension TransferMethodExtension on int {
  TransferMethod toTransferMethod() {
    return TransferMethod.values.firstWhere((type) => type.value == this);
  }
}
