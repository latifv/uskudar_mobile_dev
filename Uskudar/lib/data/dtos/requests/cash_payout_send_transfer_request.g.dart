// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_payout_send_transfer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CashPayoutSendTransferRequestToJson(
  CashPayoutSendTransferRequest instance,
) => <String, dynamic>{
  'beneficiaryCountryCode': instance.beneficiaryCountryCode,
  'beneficiaryName': instance.beneficiaryName,
  'beneficiarySurname': instance.beneficiarySurname,
  'beneficiaryGsmCountryCode': instance.beneficiaryGsmCountryCode,
  'beneficiaryGsmNo': instance.beneficiaryGsmNo,
  'amount': instance.amount,
  'moneyTakenCurrency': instance.moneyTakenCurrency,
  'transactionType': instance.transactionType,
  'transferType': instance.transferType,
  'requiredAttributes': CashPayoutSendTransferRequest._requiredAttributesToJson(
    instance.requiredAttributes,
  ),
};
