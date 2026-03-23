import 'package:json_annotation/json_annotation.dart';

part 'admin_commission_summary_response.g.dart';

@JsonSerializable(createToJson: false)
final class AdminCommissionSummaryResponse {
  const AdminCommissionSummaryResponse({
    this.item1,
    this.item2,
  });

  factory AdminCommissionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminCommissionSummaryResponseFromJson(json);

  final double? item1;
  final String? item2;
}
