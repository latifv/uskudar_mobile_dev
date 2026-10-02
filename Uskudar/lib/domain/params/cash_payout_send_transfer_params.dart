import 'package:uskudar_mobile/domain/params/key_value_attribute.dart';

class CashPayoutSendTransferParams {
  const CashPayoutSendTransferParams({
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
  final List<KeyValueAttribute> requiredAttributes;
}
