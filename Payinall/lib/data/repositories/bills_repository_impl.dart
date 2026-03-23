import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/core/generated/locale_keys.g.dart';
import 'package:payinall/data/datasources/remote/bills_remote_data_source.dart';
import 'package:payinall/data/dtos/requests/bill_inquiry_request.dart';
import 'package:payinall/data/dtos/requests/bill_payment_request.dart';
import 'package:payinall/domain/entities/bill_inquiry.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/domain/entities/bill_product_query_definition.dart';
import 'package:payinall/domain/entities/bill_product_type.dart';
import 'package:payinall/domain/params/bill_inquiry_params.dart';
import 'package:payinall/domain/params/bill_payment_params.dart';
import 'package:payinall/domain/repositories/bills_repository.dart';
import 'package:payinall/presentation/shared/extensions/string_extension.dart';

final class BillsRepositoryImpl implements BillsRepository {
  BillsRepositoryImpl({required this.remoteDataSource});

  final BillsRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<BillProductType>>> getProductTypes() async {
    try {
      final response = await remoteDataSource.getProductTypes();
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      }
      return Left(
        ServerFailure(
          message: response.message ?? LocaleKeys.unknown_error.translate,
        ),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillProduct>>> getProducts(
    String productTypeId,
  ) async {
    try {
      final response = await remoteDataSource.getProducts(productTypeId);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      }
      return Left(
        ServerFailure(
          message: response.message ?? LocaleKeys.unknown_error.translate,
        ),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillProduct>>> getCacheProductList() async {
    try {
      final response = await remoteDataSource.getCacheProductList();
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      }
      return Left(
        ServerFailure(
          message: response.message ?? LocaleKeys.unknown_error.translate,
        ),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillProductQueryDefinition>>>
  productQueryDefinition(String productId) async {
    try {
      final response = await remoteDataSource.productQueryDefinition(productId);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      }
      return Left(
        ServerFailure(
          message: response.message ?? LocaleKeys.unknown_error.translate,
        ),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BillInquiry>>> getBillInquiry(
    BillInquiryParams params,
  ) async {
    try {
      final request = BillInquiryRequest.fromParams(params);
      final response = await remoteDataSource.getBillInquiry(request);
      if (response.isSuccess && response.data != null) {
        return Right(response.data!);
      }
      return Left(
        ServerFailure(
          message: response.message ?? LocaleKeys.unknown_error.translate,
        ),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> billPayment(BillPaymentParams params) async {
    try {
      final request = BillPaymentRequest.fromParams(params);
      final response = await remoteDataSource.billPayment(request);
      if (response.isSuccess) {
        return const Right(null);
      }
      return Left(
        ServerFailure(
          message: response.message ?? LocaleKeys.unknown_error.translate,
        ),
      );
    } on Exception catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
