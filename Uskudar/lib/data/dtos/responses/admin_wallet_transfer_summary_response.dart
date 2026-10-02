import 'package:json_annotation/json_annotation.dart';

part 'admin_wallet_transfer_summary_response.g.dart';

@JsonSerializable(createToJson: false)
final class AdminWalletTransferSummaryResponse {
  const AdminWalletTransferSummaryResponse({
    this.item1,
    this.item2,
  });

  factory AdminWalletTransferSummaryResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$AdminWalletTransferSummaryResponseFromJson(json);

  final double? item1;
  final String? item2;
}
