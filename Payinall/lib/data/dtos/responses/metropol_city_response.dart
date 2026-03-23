import 'package:json_annotation/json_annotation.dart';

part 'metropol_city_response.g.dart';

@JsonSerializable(createToJson: false)
final class MetropolCityResponse {
  const MetropolCityResponse({this.city, this.county});

  factory MetropolCityResponse.fromJson(Map<String, dynamic> json) =>
      _$MetropolCityResponseFromJson(json);

  final String? city;
  final List<String>? county;
}
