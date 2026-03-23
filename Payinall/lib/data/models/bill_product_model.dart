import 'package:payinall/core/error/exceptions.dart';
import 'package:payinall/data/dtos/responses/bill_product_response.dart';
import 'package:payinall/domain/entities/bill_product.dart';

final class BillProductModel extends BillProduct {
  const BillProductModel({
    required super.productId,
    required super.productName,
  });

  factory BillProductModel.fromResponse(BillProductResponse response) {
    if (response.productId == null || response.productName == null) {
      throw const MappingException();
    }

    return BillProductModel(
      productId: response.productId!,
      productName: response.productName!,
    );
  }
}
