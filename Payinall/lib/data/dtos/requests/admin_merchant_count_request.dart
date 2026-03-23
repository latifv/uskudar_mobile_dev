import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/enums/time_type.dart';
import 'package:payinall/domain/params/admin_merchant_count_params.dart';

part 'admin_merchant_count_request.g.dart';

@JsonSerializable(createFactory: false)
final class AdminMerchantCountRequest extends AdminMerchantCountParams {
  const AdminMerchantCountRequest({
    required super.timeType,
  });

  factory AdminMerchantCountRequest.fromParams(
    AdminMerchantCountParams params,
  ) {
    return AdminMerchantCountRequest(
      timeType: params.timeType,
    );
  }

  Map<String, dynamic> toJson() => _$AdminMerchantCountRequestToJson(this);

  @JsonKey(name: 'timeTypes')
  int get timeTypes => timeType.value;
}
