import 'package:fpdart/fpdart.dart';
import 'package:payinall/core/error/failures.dart';
import 'package:payinall/domain/base/usecases/base_usecase_without_params.dart';
import 'package:payinall/domain/entities/bill_product.dart';
import 'package:payinall/domain/repositories/bills_repository.dart';

final class GetCacheProductListUsecase
    implements BaseUsecaseWithoutParams<List<BillProduct>> {
  GetCacheProductListUsecase(this.repository);

  final BillsRepository repository;

  @override
  Future<Either<Failure, List<BillProduct>>> call() async {
    final result = await repository.getCacheProductList();
    return result;
  }
}
