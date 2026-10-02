import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/domain/repositories/bills_repository.dart';

final class GetProductsUsecase
    implements BaseUsecase<List<BillProduct>, String> {
  GetProductsUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, List<BillProduct>>> call(String productTypeId) async {
    final result = await repository.getProducts(productTypeId);
    return result;
  }
}
