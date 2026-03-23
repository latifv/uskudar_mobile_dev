import 'package:json_annotation/json_annotation.dart';

part 'sector_array_response.g.dart';

@JsonSerializable(createToJson: false)
final class SectorArrayResponse {
  const SectorArrayResponse({
    this.id,
    this.letter,
    this.name,
  });

  factory SectorArrayResponse.fromJson(Map<String, dynamic> json) =>
      _$SectorArrayResponseFromJson(json);

  final int? id;
  final String? letter;
  final String? name;
}
