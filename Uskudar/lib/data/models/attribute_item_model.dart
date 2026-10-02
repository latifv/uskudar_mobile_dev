import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/attribute_item_response.dart';
import 'package:uskudar_mobile/domain/entities/attribute_item.dart';

final class AttributeItemModel extends AttributeItem {
  const AttributeItemModel({
    required super.code,
    required super.name,
  });

  factory AttributeItemModel.fromResponse(AttributeItemResponse response) {
    if (response.code == null || response.name == null) {
      throw const MappingException();
    }

    return AttributeItemModel(
      code: response.code!,
      name: response.name!,
    );
  }
}
