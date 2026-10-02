import 'package:json_annotation/json_annotation.dart';

part 'admin_merchant_count_response.g.dart';

@JsonSerializable(createToJson: false)
final class AdminMerchantCountResponse {
  const AdminMerchantCountResponse({
    this.item1,
    this.item2,
  });

  factory AdminMerchantCountResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminMerchantCountResponseFromJson(json);

  final int? item1;
  final String? item2;
}
