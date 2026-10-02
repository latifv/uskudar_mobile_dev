import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/gift_check_category_response.dart';
import 'package:uskudar_mobile/domain/entities/gift_check_category.dart';

final class GiftCheckCategoryModel extends GiftCheckCategory {
  const GiftCheckCategoryModel({
    required super.id,
    required super.name,
  });

  factory GiftCheckCategoryModel.fromResponse(
    GiftCheckCategoryResponse response,
  ) {
    if (response.id == null || response.name == null) {
      throw const MappingException();
    }

    return GiftCheckCategoryModel(
      id: response.id!,
      name: response.name!,
    );
  }
}
