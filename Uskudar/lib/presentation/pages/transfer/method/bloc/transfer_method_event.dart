part of 'transfer_method_bloc.dart';

sealed class TransferMethodEvent {
  const TransferMethodEvent();
}

final class TransferMethodLoad extends TransferMethodEvent {
  const TransferMethodLoad({this.initialMethod});

  final TransferMethod? initialMethod;
}

final class TransferMethodChanged extends TransferMethodEvent {
  const TransferMethodChanged({required this.transferMethod});

  final TransferMethod transferMethod;
}

final class RecipientWalletEntered extends TransferMethodEvent {
  const RecipientWalletEntered({required this.walletAddress});

  final String walletAddress;
}

final class RecipientPhoneEntered extends TransferMethodEvent {
  const RecipientPhoneEntered({required this.phone});

  final String phone;
}

final class BankAccountSelected extends TransferMethodEvent {
  const BankAccountSelected({required this.bankAccount});

  final CustomerBank bankAccount;
}
