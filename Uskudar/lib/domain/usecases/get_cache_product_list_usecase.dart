import 'package:fpdart/fpdart.dart';
import 'package:uskudar_mobile/core/error/failures.dart';
import 'package:uskudar_mobile/domain/base/usecases/base_usecase_without_params.dart';
import 'package:uskudar_mobile/domain/entities/bill_product.dart';
import 'package:uskudar_mobile/domain/repositories/bills_repository.dart';

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
