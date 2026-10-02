import 'package:uskudar_mobile/domain/entities/attribute_item.dart';

class RequiredAttribute {
  const RequiredAttribute({
    required this.displayName,
    this.localizationDisplayName,
    this.corporationCode,
    this.uniqueName,
    this.attributeItems,
  });

  final String? corporationCode;
  final String? uniqueName;
  final String displayName;
  final String? localizationDisplayName;
  final List<AttributeItem>? attributeItems;

  bool get hasSelectableItems =>
      attributeItems != null && attributeItems!.isNotEmpty;
}
