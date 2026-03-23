import 'package:payinall/domain/entities/required_attribute.dart';

class CorporationAttribute {
  const CorporationAttribute({
    required this.corporationCode,
    required this.corporationName,
    required this.currencyCode,
    required this.requiredAttributeList,
  });

  final String corporationCode;
  final String corporationName;
  final String currencyCode;
  final List<RequiredAttribute> requiredAttributeList;
}
