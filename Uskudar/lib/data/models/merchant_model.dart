import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/merchant_response.dart';
import 'package:payinall/data/models/sector_array_model.dart';
import 'package:payinall/domain/entities/merchant.dart';

final class MerchantModel extends Merchant {
  const MerchantModel({
    required super.id,
    required super.name,
    required super.type,
    required super.sectorArr,
    required super.logo,
    required super.sectorArray,
  });

  factory MerchantModel.fromResponse(MerchantResponse response) {
    if (response.id == null ||
        response.name == null ||
        response.type == null ||
        response.sectorArr == null ||
        response.logo == null ||
        response.sectorArray == null) {
      throw const MappingException();
    }

    return MerchantModel(
      id: response.id!,
      name: response.name!,
      type: response.type!,
      sectorArr: response.sectorArr!,
      logo: response.logo!,
      sectorArray: response.sectorArray!
          .map(SectorArrayModel.fromResponse)
          .toList(),
    );
  }
}
