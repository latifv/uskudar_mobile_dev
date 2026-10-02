import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/point_of_sale_location_response.dart';
import 'package:payinall/domain/entities/point_of_sale_location.dart';

final class PointOfSaleLocationModel extends PointOfSaleLocation {
  const PointOfSaleLocationModel({
    required super.id,
    required super.lat,
    required super.lng,
    required super.city,
    required super.district,
    required super.saleAddress,
    required super.sector,
    required super.subSector,
    required super.telNo,
    required super.signboardName,
  });

  factory PointOfSaleLocationModel.fromResponse(
    PointOfSaleLocationResponse response,
  ) {
    if (response.id == null ||
        response.lat == null ||
        response.lng == null ||
        response.city == null ||
        response.district == null) {
      throw const MappingException();
    }

    return PointOfSaleLocationModel(
      id: response.id!,
      lat: response.lat!,
      lng: response.lng!,
      city: response.city!,
      district: response.district!,
      saleAddress: response.saleAddress ?? '',
      sector: response.sector ?? '',
      subSector: response.subSector ?? '',
      telNo: response.telNo ?? '',
      signboardName: response.signboardName ?? '',
    );
  }
}
