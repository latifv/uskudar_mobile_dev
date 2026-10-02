import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/merchant_transfer_params.dart';

part 'merchant_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class MerchantTransferRequest {
  const MerchantTransferRequest({
    required this.customerNumber,
    required this.amount,
  });

  factory MerchantTransferRequest.fromParams(MerchantTransferParams params) {
    return MerchantTransferRequest(
      customerNumber: params.customerNumber,
      amount: params.amount,
    );
  }

  final String customerNumber;
  final double amount;

  Map<String, dynamic> toJson() => _$MerchantTransferRequestToJson(this);
}
