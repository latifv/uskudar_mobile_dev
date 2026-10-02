part of 'international_money_transfer_bloc.dart';

sealed class InternationalMoneyTransferEvent {
  const InternationalMoneyTransferEvent();
}

final class InternationalMoneyTransferLoadAttributes
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferLoadAttributes({
    required this.countryCode,
    this.transactionType = '001',
  });

  final String countryCode;
  final String transactionType;
}

final class InternationalMoneyTransferSubmit
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferSubmit({
    required this.beneficiaryCountryCode,
    required this.beneficiaryName,
    required this.beneficiarySurname,
    required this.beneficiaryGsmCountryCode,
    required this.beneficiaryGsmNo,
    required this.amount,
    required this.moneyTakenCurrency,
    required this.transactionType,
    required this.transferType,
    required this.requiredAttributes,
  });

  final String beneficiaryCountryCode;
  final String beneficiaryName;
  final String beneficiarySurname;
  final String beneficiaryGsmCountryCode;
  final String beneficiaryGsmNo;
  final double amount;
  final String moneyTakenCurrency;
  final String transactionType;
  final String transferType;
  final Map<String, String> requiredAttributes;
}

final class InternationalMoneyTransferConfirm
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferConfirm({required this.transactionId});

  final String transactionId;
}

final class InternationalMoneyTransferReset
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferReset();
}

final class InternationalMoneyTransferSelectCorporation
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferSelectCorporation({
    required this.corporation,
  });

  final CorporationAttribute corporation;
}

final class InternationalMoneyTransferLoadBicBankList
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferLoadBicBankList({
    required this.countryCode,
    required this.corporationCode,
  });

  final String countryCode;
  final String corporationCode;
}

final class InternationalMoneyTransferLoadOffices
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferLoadOffices({
    required this.countryCode,
    required this.officeType,
    required this.corporationCode,
  });

  final String countryCode;
  final String officeType;
  final String corporationCode;
}

final class InternationalMoneyTransferLoadCardBinCode
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferLoadCardBinCode({
    required this.countryCode,
  });

  final String countryCode;
}

final class InternationalMoneyTransferLoadWalletOperator
    extends InternationalMoneyTransferEvent {
  const InternationalMoneyTransferLoadWalletOperator({
    required this.countryCode,
  });

  final String countryCode;
}
