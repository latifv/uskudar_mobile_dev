part of 'add_bank_account_bloc.dart';

sealed class AddBankAccountEvent {
  const AddBankAccountEvent();
}

final class AddBankAccountSave extends AddBankAccountEvent {
  const AddBankAccountSave({required this.title, required this.iban});

  final String title;
  final String iban;
}
