import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase.dart';
import 'package:uskudar_mobile/domain/entities/bill_product.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';

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
