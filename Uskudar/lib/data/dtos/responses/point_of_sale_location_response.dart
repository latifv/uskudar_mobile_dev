import 'package:json_annotation/json_annotation.dart';

part 'point_of_sale_location_response.g.dart';

@JsonSerializable(createToJson: false)
final class PointOfSaleLocationResponse {
  const PointOfSaleLocationResponse({
    this.id,
    this.lat,
    this.lng,
    this.city,
    this.district,
    this.saleAddress,
    this.sector,
    this.subSector,
    this.telNo,
    this.signboardName,
  });

  factory PointOfSaleLocationResponse.fromJson(Map<String, dynamic> json) =>
      _$PointOfSaleLocationResponseFromJson(json);

  final String? id;
  final String? lat;
  final String? lng;
  final String? city;
  final String? district;
  @JsonKey(name: 'sale_address')
  final String? saleAddress;
  final String? sector;
  @JsonKey(name: 'sub_sector')
  final String? subSector;
  @JsonKey(name: 'tel_no')
  final String? telNo;
  @JsonKey(name: 'signboard_name')
  final String? signboardName;
}
