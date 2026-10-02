import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/data/dtos/requests/key_value_attribute_request.dart';
import 'package:uskudar_mobile/domain/params/cash_payout_send_transfer_params.dart';
import 'package:uskudar_mobile/domain/params/key_value_attribute.dart';

part 'cash_payout_send_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class CashPayoutSendTransferRequest extends CashPayoutSendTransferParams {
  const CashPayoutSendTransferRequest({
    required super.beneficiaryCountryCode,
    required super.beneficiaryName,
    required super.beneficiarySurname,
    required super.beneficiaryGsmCountryCode,
    required super.beneficiaryGsmNo,
    required super.amount,
    required super.moneyTakenCurrency,
    required super.transactionType,
    required super.transferType,
    required super.requiredAttributes,
  });

  factory CashPayoutSendTransferRequest.fromParams(
    CashPayoutSendTransferParams params,
  ) {
    return CashPayoutSendTransferRequest(
      beneficiaryCountryCode: params.beneficiaryCountryCode,
      beneficiaryName: params.beneficiaryName,
      beneficiarySurname: params.beneficiarySurname,
      beneficiaryGsmCountryCode: params.beneficiaryGsmCountryCode,
      beneficiaryGsmNo: params.beneficiaryGsmNo,
      amount: params.amount,
      moneyTakenCurrency: params.moneyTakenCurrency,
      transactionType: params.transactionType,
      transferType: params.transferType,
      requiredAttributes: params.requiredAttributes,
    );
  }

  @override
  @JsonKey(name: 'requiredAttributes', toJson: _requiredAttributesToJson)
  List<KeyValueAttribute> get requiredAttributes => super.requiredAttributes;

  static List<Map<String, dynamic>> _requiredAttributesToJson(
    List<KeyValueAttribute> attributes,
  ) {
    return attributes
        .map((attr) => KeyValueAttributeRequest.fromDomain(attr).toJson())
        .toList();
  }

  Map<String, dynamic> toJson() => _$CashPayoutSendTransferRequestToJson(this);
}
