import 'package:json_annotation/json_annotation.dart';

part 'office_response.g.dart';

@JsonSerializable()
final class OfficeResponse {
  const OfficeResponse({
    this.officeAddress,
    this.officeCityName,
    this.officeCode,
    this.officeCountryName,
    this.officeName,
    this.officePhone,
  });

  factory OfficeResponse.fromJson(Map<String, dynamic> json) =>
      _$OfficeResponseFromJson(json);

  final String? officeAddress;
  final String? officeCityName;
  final String? officeCode;
  final String? officeCountryName;
  final String? officeName;
  final String? officePhone;

  Map<String, dynamic> toJson() => _$OfficeResponseToJson(this);
}
