import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/corporation_attribute_response.dart';
import 'package:uskudar_mobile/data/models/required_attribute_model.dart';
import 'package:uskudar_mobile/domain/entities/corporation_attribute.dart';
import 'package:uskudar_mobile/domain/entities/required_attribute.dart';

final class CorporationAttributeModel extends CorporationAttribute {
  const CorporationAttributeModel({
    required super.corporationCode,
    required super.corporationName,
    required super.currencyCode,
    required super.requiredAttributeList,
  });

  factory CorporationAttributeModel.fromResponse(
    CorporationAttributeResponse response,
  ) {
    if (response.corporationCode == null ||
        response.corporationName == null ||
        response.currencyCode == null ||
        response.requiredAttributeList == null) {
      throw const MappingException();
    }

    final List<RequiredAttribute> requiredAttributeList = response
        .requiredAttributeList!
        .map(RequiredAttributeModel.fromResponse)
        .toList();

    return CorporationAttributeModel(
      corporationCode: response.corporationCode!,
      corporationName: response.corporationName!,
      currencyCode: response.currencyCode!,
      requiredAttributeList: requiredAttributeList,
    );
  }
}
