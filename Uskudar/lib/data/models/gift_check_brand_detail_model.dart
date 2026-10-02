import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_brand_detail_response.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_brand_detail.dart';

final class GiftCheckBrandDetailModel extends GiftCheckBrandDetail {
  const GiftCheckBrandDetailModel({
    required super.id,
    required super.name,
    required super.description,
    required super.logo,
    required super.banner,
    required super.cashbackRate,
    required super.kdvRate,
  });

  factory GiftCheckBrandDetailModel.fromResponse(
    GiftCheckBrandDetailResponse response,
  ) {
    if (response.id == null ||
        response.name == null ||
        response.description == null ||
        response.logo == null ||
        response.banner == null ||
        response.cashbackRate == null ||
        response.kdvRate == null) {
      throw const MappingException();
    }

    return GiftCheckBrandDetailModel(
      id: response.id!,
      name: response.name!,
      description: response.description!,
      logo: response.logo!,
      banner: response.banner!,
      cashbackRate: response.cashbackRate!,
      kdvRate: response.kdvRate!,
    );
  }
}
