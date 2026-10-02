import 'package:uskudar_mobile/core/error/exceptions.dart';
import 'package:uskudar_mobile/data/dtos/responses/bill_product_type_response.dart';
import 'package:uskudar_mobile/domain/entities/bill_product_type.dart';

final class BillProductTypeModel extends BillProductType {
  const BillProductTypeModel({
    required super.productTypeId,
    required super.productTypeName,
  });

  factory BillProductTypeModel.fromResponse(BillProductTypeResponse response) {
    if (response.productTypeId == null || response.productTypeName == null) {
      throw const MappingException();
    }

    return BillProductTypeModel(
      productTypeId: response.productTypeId!,
      productTypeName: response.productTypeName!,
    );
  }
}
