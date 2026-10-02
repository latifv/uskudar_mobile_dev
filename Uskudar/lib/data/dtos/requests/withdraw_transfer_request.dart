import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/withdraw_transfer_params.dart';

part 'withdraw_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class WithdrawTransferRequest extends WithdrawTransferParams {
  const WithdrawTransferRequest({
    required super.ibanNumber,
    required super.amount,
  });

  factory WithdrawTransferRequest.fromParams(WithdrawTransferParams params) {
    return WithdrawTransferRequest(
      ibanNumber: params.ibanNumber,
      amount: params.amount,
    );
  }

  Map<String, dynamic> toJson() => _$WithdrawTransferRequestToJson(this);
}
