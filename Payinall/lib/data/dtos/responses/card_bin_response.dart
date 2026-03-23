import 'package:json_annotation/json_annotation.dart';

part 'card_bin_response.g.dart';

@JsonSerializable()
final class CardBinResponse {
  const CardBinResponse({
    this.prefix,
  });

  factory CardBinResponse.fromJson(Map<String, dynamic> json) =>
      _$CardBinResponseFromJson(json);

  final String? prefix;

  Map<String, dynamic> toJson() => _$CardBinResponseToJson(this);
}
