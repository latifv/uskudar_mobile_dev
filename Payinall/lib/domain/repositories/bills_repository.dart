import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/entities/bill_inquiry.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/domain/entities/bill_product_query_definition.dart';
import 'package:payinall/domain/entities/bill_product_type.dart';
import 'package:payinall/domain/params/bill_inquiry_params.dart';
import 'package:payinall/domain/params/bill_payment_params.dart';

abstract interface class BillsRepository {
  Future<Either<Failure, List<BillProductType>>> getProductTypes();
  Future<Either<Failure, List<BillProduct>>> getProducts(String productTypeId);
  Future<Either<Failure, List<BillProduct>>> getCacheProductList();
  Future<Either<Failure, List<BillProductQueryDefinition>>>
  productQueryDefinition(String productId);
  Future<Either<Failure, List<BillInquiry>>> getBillInquiry(
    BillInquiryParams params,
  );
  Future<Either<Failure, void>> billPayment(BillPaymentParams params);
}
