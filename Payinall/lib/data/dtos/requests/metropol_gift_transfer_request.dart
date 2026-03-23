import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/metropol_gift_transfer_params.dart';

part 'metropol_gift_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class MetropolGiftTransferRequest extends MetropolGiftTransferParams {
  const MetropolGiftTransferRequest({required super.amount});

  factory MetropolGiftTransferRequest.fromParams(
    MetropolGiftTransferParams params,
  ) {
    return MetropolGiftTransferRequest(amount: params.amount);
  }

  Map<String, dynamic> toJson() => _$MetropolGiftTransferRequestToJson(this);
}
