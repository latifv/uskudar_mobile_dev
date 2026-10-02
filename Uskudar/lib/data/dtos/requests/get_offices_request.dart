import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/get_offices_params.dart';

part 'get_offices_request.g.dart';

@JsonSerializable()
final class GetOfficesRequest extends GetOfficesParams {
  const GetOfficesRequest({
    required super.countryCode,
    required super.officeType,
    required super.corporationCode,
  });

  factory GetOfficesRequest.fromJson(Map<String, dynamic> json) =>
      _$GetOfficesRequestFromJson(json);

  factory GetOfficesRequest.fromParams(GetOfficesParams params) =>
      GetOfficesRequest(
        countryCode: params.countryCode,
        officeType: params.officeType,
        corporationCode: params.corporationCode,
      );

  Map<String, dynamic> toJson() => _$GetOfficesRequestToJson(this);
}
