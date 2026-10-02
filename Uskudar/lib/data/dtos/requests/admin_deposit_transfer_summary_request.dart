import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/admin_deposit_transfer_summary_params.dart';

part 'admin_deposit_transfer_summary_request.g.dart';

@JsonSerializable(createFactory: false, ignoreUnannotated: true)
final class AdminDepositTransferSummaryRequest
    extends AdminDepositTransferSummaryParams {
  const AdminDepositTransferSummaryRequest({
    required super.timeType,
  });

  factory AdminDepositTransferSummaryRequest.fromParams(
    AdminDepositTransferSummaryParams params,
  ) {
    return AdminDepositTransferSummaryRequest(
      timeType: params.timeType,
    );
  }

  Map<String, dynamic> toJson() =>
      _$AdminDepositTransferSummaryRequestToJson(this);

  @JsonKey(name: 'timeTypes')
  int get timeTypeValue => timeType.value;
}
