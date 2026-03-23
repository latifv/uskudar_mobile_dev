import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/merchant_withdraw_transfer_params.dart';

part 'merchant_withdraw_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class MerchantWithdrawTransferRequest
    extends MerchantWithdrawTransferParams {
  const MerchantWithdrawTransferRequest({
    required super.ibanNumber,
    required super.amount,
    required super.firstName,
    required super.lastName,
    required super.description,
  });

  factory MerchantWithdrawTransferRequest.fromParams(
    MerchantWithdrawTransferParams params,
  ) {
    return MerchantWithdrawTransferRequest(
      ibanNumber: params.ibanNumber,
      amount: params.amount,
      firstName: params.firstName,
      lastName: params.lastName,
      description: params.description,
    );
  }

  Map<String, dynamic> toJson() =>
      _$MerchantWithdrawTransferRequestToJson(this);
}
