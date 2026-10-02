import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/bill_product_type_response.dart';
import 'package:payinall/domain/entities/bill_product_type.dart';

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
