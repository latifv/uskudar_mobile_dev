import 'package:json_annotation/json_annotation.dart';

part 'admin_withdraw_transfer_summary_response.g.dart';

@JsonSerializable(createToJson: false)
final class AdminWithdrawTransferSummaryResponse {
  const AdminWithdrawTransferSummaryResponse({
    this.item1,
    this.item2,
  });

  factory AdminWithdrawTransferSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AdminWithdrawTransferSummaryResponseFromJson(json);

  final double? item1;
  final String? item2;
}
