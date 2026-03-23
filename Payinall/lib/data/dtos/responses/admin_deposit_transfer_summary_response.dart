import 'package:json_annotation/json_annotation.dart';

part 'admin_deposit_transfer_summary_response.g.dart';

@JsonSerializable(createToJson: false)
final class AdminDepositTransferSummaryResponse {
  const AdminDepositTransferSummaryResponse({
    this.item1,
    this.item2,
  });

  factory AdminDepositTransferSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AdminDepositTransferSummaryResponseFromJson(json);

  final double? item1;
  final String? item2;
}
