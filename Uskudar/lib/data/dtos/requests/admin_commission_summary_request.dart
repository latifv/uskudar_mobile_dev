import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/admin_commission_summary_params.dart';

part 'admin_commission_summary_request.g.dart';

@JsonSerializable(createFactory: false, ignoreUnannotated: true)
final class AdminCommissionSummaryRequest extends AdminCommissionSummaryParams {
  const AdminCommissionSummaryRequest({
    required super.timeType,
  });

  factory AdminCommissionSummaryRequest.fromParams(
    AdminCommissionSummaryParams params,
  ) {
    return AdminCommissionSummaryRequest(
      timeType: params.timeType,
    );
  }

  Map<String, dynamic> toJson() => _$AdminCommissionSummaryRequestToJson(this);

  @JsonKey(name: 'timeType')
  int get timeTypeValue => timeType.value;
}
