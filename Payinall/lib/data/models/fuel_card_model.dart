import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/fuel_card_response.dart';
import 'package:payinall/domain/entities/fuel_card.dart';

final class FuelCardModel extends FuelCard {
  const FuelCardModel({
    required super.id,
    required super.cardNo,
    required super.isActive,
    required super.cardType,
    required super.cardTypeName,
    required super.createdDate,
  });

  factory FuelCardModel.fromResponse(FuelCardResponse response) {
    if (response.id == null ||
        response.cardNo == null ||
        response.isActive == null ||
        response.cardType == null ||
        response.cardTypeName == null ||
        response.createdDate == null) {
      throw const MappingException();
    }

    return FuelCardModel(
      id: response.id!,
      cardNo: response.cardNo!,
      isActive: response.isActive!,
      cardType: response.cardType!,
      cardTypeName: response.cardTypeName!,
      createdDate: response.createdDate!,
    );
  }
}
