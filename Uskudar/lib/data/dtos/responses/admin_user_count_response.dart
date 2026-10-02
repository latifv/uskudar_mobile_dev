import 'package:json_annotation/json_annotation.dart';

part 'admin_user_count_response.g.dart';

@JsonSerializable(createToJson: false)
final class AdminUserCountResponse {
  const AdminUserCountResponse({
    this.item1,
    this.item2,
  });

  factory AdminUserCountResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminUserCountResponseFromJson(json);

  final int? item1;
  final String? item2;
}
