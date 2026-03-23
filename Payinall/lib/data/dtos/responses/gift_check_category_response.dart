import 'package:json_annotation/json_annotation.dart';

part 'gift_check_category_response.g.dart';

@JsonSerializable(createToJson: false)
final class GiftCheckCategoryResponse {
  const GiftCheckCategoryResponse({this.id, this.name});

  factory GiftCheckCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$GiftCheckCategoryResponseFromJson(json);

  final String? id;
  final String? name;
}
