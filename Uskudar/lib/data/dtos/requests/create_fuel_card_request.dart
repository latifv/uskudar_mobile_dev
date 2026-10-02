import 'package:json_annotation/json_annotation.dart';
import 'package:uskudar_mobile/domain/params/create_fuel_card_params.dart';

part 'create_fuel_card_request.g.dart';

@JsonSerializable(createFactory: false)
final class CreateFuelCardRequest extends CreateFuelCardParams {
  const CreateFuelCardRequest({
    required super.cardNo,
    required super.cardType,
    super.plate,
    super.fuelType,
  });

  factory CreateFuelCardRequest.fromParams(CreateFuelCardParams params) {
    return CreateFuelCardRequest(
      cardNo: params.cardNo,
      cardType: params.cardType,
      plate: params.plate,
      fuelType: params.fuelType,
    );
  }

  Map<String, dynamic> toJson() => _$CreateFuelCardRequestToJson(this);
}
