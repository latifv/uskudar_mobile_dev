import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/metropol_draw_back_transfer_params.dart';

part 'metropol_draw_back_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class MetropolDrawBackTransferRequest
    extends MetropolDrawBackTransferParams {
  const MetropolDrawBackTransferRequest({required super.metropolType});

  factory MetropolDrawBackTransferRequest.fromParams(
    MetropolDrawBackTransferParams params,
  ) {
    return MetropolDrawBackTransferRequest(metropolType: params.metropolType);
  }

  Map<String, dynamic> toJson() =>
      _$MetropolDrawBackTransferRequestToJson(this);
}
