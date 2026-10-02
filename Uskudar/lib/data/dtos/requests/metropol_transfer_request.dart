import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/metropol_transfer_params.dart';

part 'metropol_transfer_request.g.dart';

@JsonSerializable(createFactory: false)
final class MetropolTransferRequest extends MetropolTransferParams {
  const MetropolTransferRequest({
    required super.codeTypes,
    required super.code,
  });

  factory MetropolTransferRequest.fromParams(MetropolTransferParams params) {
    return MetropolTransferRequest(
      codeTypes: params.codeTypes,
      code: params.code,
    );
  }

  Map<String, dynamic> toJson() => _$MetropolTransferRequestToJson(this);
}
