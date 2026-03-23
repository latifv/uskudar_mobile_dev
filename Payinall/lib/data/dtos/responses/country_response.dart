import 'package:json_annotation/json_annotation.dart';

part 'country_response.g.dart';

@JsonSerializable(createToJson: false)
final class CountryResponse {
  const CountryResponse({
    this.countryName,
    this.countryCode,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) =>
      _$CountryResponseFromJson(json);

  final String? countryName;
  final String? countryCode;
}
