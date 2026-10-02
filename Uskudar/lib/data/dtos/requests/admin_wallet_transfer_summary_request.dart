import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/admin_wallet_transfer_summary_params.dart';

part 'admin_wallet_transfer_summary_request.g.dart';

@JsonSerializable(createFactory: false, ignoreUnannotated: true)
final class AdminWalletTransferSummaryRequest
    extends AdminWalletTransferSummaryParams {
  const AdminWalletTransferSummaryRequest({
    required super.timeType,
  });

  factory AdminWalletTransferSummaryRequest.fromParams(
    AdminWalletTransferSummaryParams params,
  ) {
    return AdminWalletTransferSummaryRequest(
      timeType: params.timeType,
    );
  }

  Map<String, dynamic> toJson() =>
      _$AdminWalletTransferSummaryRequestToJson(this);

  @JsonKey(name: 'timeTypes')
  int get timeTypeValue => timeType.value;
}
