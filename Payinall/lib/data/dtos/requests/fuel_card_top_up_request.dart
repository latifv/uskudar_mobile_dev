import 'package:json_annotation/json_annotation.dart';
import 'package:payinall/domain/params/fuel_card_top_up_params.dart';

part 'fuel_card_top_up_request.g.dart';

@JsonSerializable(createFactory: false)
final class FuelCardTopUpRequest extends FuelCardTopUpParams {
  const FuelCardTopUpRequest({
    required super.fuelCardId,
    required super.amount,
  });

  factory FuelCardTopUpRequest.fromParams(FuelCardTopUpParams params) {
    return FuelCardTopUpRequest(
      fuelCardId: params.fuelCardId,
      amount: params.amount,
    );
  }

  Map<String, dynamic> toJson() => _$FuelCardTopUpRequestToJson(this);
}
