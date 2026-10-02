import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/country_response.dart';
import 'package:payinall/domain/entities/country.dart';

final class CountryModel extends Country {
  const CountryModel({
    required super.countryName,
    required super.countryCode,
  });

  factory CountryModel.fromResponse(CountryResponse response) {
    if (response.countryName == null || response.countryCode == null) {
      throw const MappingException();
    }

    return CountryModel(
      countryName: response.countryName!,
      countryCode: response.countryCode!,
    );
  }
}
