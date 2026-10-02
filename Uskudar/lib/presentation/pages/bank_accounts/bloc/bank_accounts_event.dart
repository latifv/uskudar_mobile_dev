part of 'bank_accounts_bloc.dart';

sealed class BankAccountsEvent {
  const BankAccountsEvent();
}

final class BankAccountsLoad extends BankAccountsEvent {
  const BankAccountsLoad();
}

final class BankAccountsDelete extends BankAccountsEvent {
  const BankAccountsDelete({required this.ibanNumber});

  final String ibanNumber;
}
