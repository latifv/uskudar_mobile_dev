import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_complete_params.dart';

part 'metropol_transfer_complete_request.g.dart';

@JsonSerializable(createFactory: false)
final class MetropolTransferCompleteRequest
    extends MetropolTransferCompleteParams {
  const MetropolTransferCompleteRequest({required super.transactionId});

  factory MetropolTransferCompleteRequest.fromParams(
    MetropolTransferCompleteParams params,
  ) {
    return MetropolTransferCompleteRequest(
      transactionId: params.transactionId,
    );
  }

  Map<String, dynamic> toJson() =>
      _$MetropolTransferCompleteRequestToJson(this);
}
