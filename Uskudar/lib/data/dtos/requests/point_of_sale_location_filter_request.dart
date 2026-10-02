import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/point_of_sale_location_filter_params.dart';

part 'point_of_sale_location_filter_request.g.dart';

@JsonSerializable(createFactory: false)
final class PointOfSaleLocationFilterRequest
    extends PointOfSaleLocationFilterParams {
  const PointOfSaleLocationFilterRequest({
    required super.name,
    required super.city,
    required super.county,
    required super.metropolTypes,
  });

  factory PointOfSaleLocationFilterRequest.fromParams(
    PointOfSaleLocationFilterParams params,
  ) {
    return PointOfSaleLocationFilterRequest(
      name: params.name,
      city: params.city,
      county: params.county,
      metropolTypes: params.metropolTypes,
    );
  }

  Map<String, dynamic> toJson() =>
      _$PointOfSaleLocationFilterRequestToJson(this);
}
