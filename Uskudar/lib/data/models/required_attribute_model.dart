import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/required_attribute_response.dart';
import 'package:uskudar_mobile/data/models/attribute_item_model.dart';
import 'package:uskudar_mobile/domain/entities/attribute_item.dart';
import 'package:uskudar_mobile/domain/entities/required_attribute.dart';

final class RequiredAttributeModel extends RequiredAttribute {
  const RequiredAttributeModel({
    required super.displayName,
    super.localizationDisplayName,
    super.corporationCode,
    super.uniqueName,
    super.attributeItems,
  });

  factory RequiredAttributeModel.fromResponse(
    RequiredAttributeResponse response,
  ) {
    if (response.displayName == null) {
      throw const MappingException();
    }

    List<AttributeItem>? attributeItems;
    if (response.attributeItems != null) {
      attributeItems = response.attributeItems!
          .map(AttributeItemModel.fromResponse)
          .toList();
    }

    return RequiredAttributeModel(
      corporationCode: response.corporationCode,
      uniqueName: response.uniqueName,
      displayName: response.displayName!,
      localizationDisplayName: response.localizationDisplayName,
      attributeItems: attributeItems,
    );
  }
}
