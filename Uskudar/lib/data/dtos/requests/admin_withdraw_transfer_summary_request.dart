import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/admin_withdraw_transfer_summary_params.dart';

part 'admin_withdraw_transfer_summary_request.g.dart';

@JsonSerializable(createFactory: false, ignoreUnannotated: true)
final class AdminWithdrawTransferSummaryRequest
    extends AdminWithdrawTransferSummaryParams {
  const AdminWithdrawTransferSummaryRequest({
    required super.timeType,
  });

  factory AdminWithdrawTransferSummaryRequest.fromParams(
    AdminWithdrawTransferSummaryParams params,
  ) {
    return AdminWithdrawTransferSummaryRequest(
      timeType: params.timeType,
    );
  }

  Map<String, dynamic> toJson() =>
      _$AdminWithdrawTransferSummaryRequestToJson(this);

  @JsonKey(name: 'timeTypes')
  int get timeTypeValue => timeType.value;
}
