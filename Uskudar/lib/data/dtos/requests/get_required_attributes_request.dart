import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/get_required_attributes_params.dart';

part 'get_required_attributes_request.g.dart';

@JsonSerializable(createFactory: false)
final class GetRequiredAttributesRequest extends GetRequiredAttributesParams {
  const GetRequiredAttributesRequest({
    required super.countryCode,
    required super.transactionType,
  });

  factory GetRequiredAttributesRequest.fromParams(
    GetRequiredAttributesParams params,
  ) {
    return GetRequiredAttributesRequest(
      countryCode: params.countryCode,
      transactionType: params.transactionType,
    );
  }

  Map<String, dynamic> toJson() => _$GetRequiredAttributesRequestToJson(this);
}
