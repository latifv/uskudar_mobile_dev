import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_brand_response.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand.dart';

final class GiftCheckBrandModel extends GiftCheckBrand {
  const GiftCheckBrandModel({
    required super.id,
    required super.name,
    required super.cashbackRate,
    required super.logo,
  });

  factory GiftCheckBrandModel.fromResponse(GiftCheckBrandResponse response) {
    if (response.id == null ||
        response.name == null ||
        response.cashbackRate == null ||
        response.logo == null) {
      throw const MappingException();
    }

    return GiftCheckBrandModel(
      id: response.id!,
      name: response.name!,
      cashbackRate: response.cashbackRate!,
      logo: response.logo!,
    );
  }
}
