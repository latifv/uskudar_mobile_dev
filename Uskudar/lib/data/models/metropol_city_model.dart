import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/metropol_city_response.dart';
import 'package:uskudar_mobile/domain/entities/metropol_city.dart';

final class MetropolCityModel extends MetropolCity {
  const MetropolCityModel({
    required super.city,
    required super.county,
  });

  factory MetropolCityModel.fromResponse(MetropolCityResponse response) {
    if (response.city == null || response.county == null) {
      throw const MappingException();
    }

    return MetropolCityModel(
      city: response.city!,
      county: response.county!,
    );
  }
}
