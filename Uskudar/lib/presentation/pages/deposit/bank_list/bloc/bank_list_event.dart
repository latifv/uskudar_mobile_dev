sealed class BankListEvent {
  const BankListEvent();
}

final class BankListFetched extends BankListEvent {
  const BankListFetched();
}

final class BankSelected extends BankListEvent {
  const BankSelected({required this.bankId});

  final int bankId;
}
