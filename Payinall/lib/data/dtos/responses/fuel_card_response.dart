import 'package:json_annotation/json_annotation.dart';

part 'fuel_card_response.g.dart';

@JsonSerializable(createToJson: false)
final class FuelCardResponse {
  const FuelCardResponse({
    this.id,
    this.cardNo,
    this.isActive,
    this.cardType,
    this.cardTypeName,
    this.createdDate,
  });

  factory FuelCardResponse.fromJson(Map<String, dynamic> json) =>
      _$FuelCardResponseFromJson(json);

  final int? id;
  final String? cardNo;
  final bool? isActive;
  final int? cardType;
  final String? cardTypeName;
  final String? createdDate;
}
