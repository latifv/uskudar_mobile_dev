import 'package:payinall/domain/entities/app_bank.dart';

sealed class BankDetailEvent {
  const BankDetailEvent();
}

final class BankDetailFetched extends BankDetailEvent {
  const BankDetailFetched({required this.bank});

  final AppBank bank;
}

final class BankDetailWalletAddressFetched extends BankDetailEvent {
  const BankDetailWalletAddressFetched();
}
