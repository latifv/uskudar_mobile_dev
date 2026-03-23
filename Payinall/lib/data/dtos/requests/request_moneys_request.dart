import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/request_moneys_params.dart';

part 'request_moneys_request.g.dart';

@JsonSerializable(createFactory: false)
final class RequestMoneyRequest extends RequestMoneyParams {
  const RequestMoneyRequest({
    required super.money,
    required super.description,
    required super.fromAddress,
  });

  factory RequestMoneyRequest.fromParams(RequestMoneyParams params) {
    return RequestMoneyRequest(
      money: params.money,
      description: params.description,
      fromAddress: params.fromAddress,
    );
  }

  Map<String, dynamic> toJson() => _$RequestMoneyRequestToJson(this);
}
