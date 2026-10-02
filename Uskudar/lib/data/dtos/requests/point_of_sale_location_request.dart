import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/point_of_sale_location_params.dart';

part 'point_of_sale_location_request.g.dart';

@JsonSerializable(createFactory: false)
final class PointOfSaleLocationRequest extends PointOfSaleLocationParams {
  const PointOfSaleLocationRequest({
    required super.lat1,
    required super.lat2,
    required super.lng1,
    required super.lng2,
  });

  factory PointOfSaleLocationRequest.fromParams(
    PointOfSaleLocationParams params,
  ) {
    return PointOfSaleLocationRequest(
      lat1: params.lat1,
      lat2: params.lat2,
      lng1: params.lng1,
      lng2: params.lng2,
    );
  }

  Map<String, dynamic> toJson() => _$PointOfSaleLocationRequestToJson(this);
}
