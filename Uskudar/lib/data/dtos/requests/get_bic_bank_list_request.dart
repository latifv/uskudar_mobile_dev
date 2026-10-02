import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/get_bic_bank_list_params.dart';

part 'get_bic_bank_list_request.g.dart';

@JsonSerializable()
final class GetBicBankListRequest extends GetBicBankListParams {
  const GetBicBankListRequest({
    required super.countryCode,
    required super.corporationCode,
  });

  factory GetBicBankListRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBicBankListRequestFromJson(json);

  factory GetBicBankListRequest.fromParams(GetBicBankListParams params) =>
      GetBicBankListRequest(
        countryCode: params.countryCode,
        corporationCode: params.corporationCode,
      );

  Map<String, dynamic> toJson() => _$GetBicBankListRequestToJson(this);
}
