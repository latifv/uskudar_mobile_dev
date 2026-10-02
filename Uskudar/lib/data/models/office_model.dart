import 'package:uskudar_mobile/data/dtos/responses/office_response.dart';
import 'package:uskudar_mobile/domain/entities/office.dart';

final class OfficeModel extends Office {
  const OfficeModel({
    required super.officeAddress,
    required super.officeCityName,
    required super.officeCode,
    required super.officeCountryName,
    required super.officeName,
    required super.officePhone,
  });

  factory OfficeModel.fromResponse(OfficeResponse response) => OfficeModel(
    officeAddress: response.officeAddress ?? '',
    officeCityName: response.officeCityName ?? '',
    officeCode: response.officeCode ?? '',
    officeCountryName: response.officeCountryName ?? '',
    officeName: response.officeName ?? '',
    officePhone: response.officePhone ?? '',
  );

  Office toEntity() => Office(
    officeAddress: officeAddress,
    officeCityName: officeCityName,
    officeCode: officeCode,
    officeCountryName: officeCountryName,
    officeName: officeName,
    officePhone: officePhone,
  );
}
